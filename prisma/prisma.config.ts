import { defineConfig } from '@prisma/client/config'

export default defineConfig({
  databases: {
    default: {
      url: process.env.DATABASE_URL || 'postgresql://user:password@localhost:5432/stockel?schema=public'
    }
  }
})
