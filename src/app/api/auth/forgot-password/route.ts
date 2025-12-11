import { NextRequest, NextResponse } from 'next/server'
import crypto from 'crypto'
import { prisma } from '@/lib/prisma'
import nodemailer from 'nodemailer'

export async function POST(request: NextRequest) {
  try {
    const { email } = await request.json()

    if (!email) {
      return NextResponse.json(
        { error: 'Email es requerido' },
        { status: 400 }
      )
    }

    // Buscar el usuario
    const user = await prisma.user.findUnique({
      where: { email }
    })

    if (!user) {
      // Por seguridad, no revelar si el email existe o no
      return NextResponse.json({
        message: 'Si el email existe, recibirás un enlace de recuperación'
      })
    }

    // Generar token de recuperación
    const resetToken = crypto.randomBytes(32).toString('hex')
    const resetTokenExpiry = new Date(Date.now() + 3600000) // 1 hora

    // Guardar el token en la base de datos
    await prisma.user.update({
      where: { email },
      data: {
        resetToken,
        resetTokenExpiry
      }
    })

    // Crear el enlace de recuperación
    const resetUrl = `${process.env.NEXTAUTH_URL}/reset-password?token=${resetToken}`

    // Configurar el transporter de nodemailer
    const transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: parseInt(process.env.SMTP_PORT || '587'),
      secure: false,
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASSWORD
      }
    })

    // Enviar el email
    try {
      await transporter.sendMail({
        from: process.env.EMAIL_FROM,
        to: email,
        subject: 'Recuperación de contraseña - Stockël',
        html: `
          <h1>Recuperación de contraseña</h1>
          <p>Has solicitado recuperar tu contraseña.</p>
          <p>Haz clic en el siguiente enlace para crear una nueva contraseña:</p>
          <a href="${resetUrl}">${resetUrl}</a>
          <p>Este enlace expirará en 1 hora.</p>
          <p>Si no solicitaste este cambio, ignora este email.</p>
        `
      })
    } catch (emailError) {
      console.error('Error al enviar email:', emailError)
      // Continuar sin fallar si el email no se puede enviar
    }

    return NextResponse.json({
      message: 'Si el email existe, recibirás un enlace de recuperación'
    })
  } catch (error) {
    console.error('Error en recuperación de contraseña:', error)
    return NextResponse.json(
      { error: 'Error al procesar la solicitud' },
      { status: 500 }
    )
  }
}
