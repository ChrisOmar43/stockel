import { NextRequest, NextResponse } from 'next/server'
import bcrypt from 'bcryptjs'
import { prisma } from '@/lib/prisma'

export async function POST(request: NextRequest) {
  try {
    const { token, password } = await request.json()

    if (!token || !password) {
      return NextResponse.json(
        { error: 'Token y contraseña son requeridos' },
        { status: 400 }
      )
    }

    // Buscar el usuario con el token válido
    const user = await prisma.user.findFirst({
      where: {
        resetToken: token,
        resetTokenExpiry: {
          gt: new Date() // Token no expirado
        }
      }
    })

    if (!user) {
      return NextResponse.json(
        { error: 'Token inválido o expirado' },
        { status: 400 }
      )
    }

    // Hashear la nueva contraseña
    const hashedPassword = await bcrypt.hash(password, 10)

    // Actualizar la contraseña y limpiar el token
    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
        resetToken: null,
        resetTokenExpiry: null
      }
    })

    return NextResponse.json({
      message: 'Contraseña actualizada exitosamente'
    })
  } catch (error) {
    console.error('Error al resetear contraseña:', error)
    return NextResponse.json(
      { error: 'Error al resetear la contraseña' },
      { status: 500 }
    )
  }
}
