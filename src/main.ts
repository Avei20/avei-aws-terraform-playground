import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger'
import serverlessExpress from '@codegenie/serverless-express'
import { Callback, Context, Handler } from 'aws-lambda'

let server: Handler

async function bootstrap() {
  const app = await NestFactory.create(AppModule)
  app.enableCors()

  const options = new DocumentBuilder()
    .setTitle('FeedLoop Take Home Test API')
    .setDescription("FeedLoop's Take Home Test API")
    .setVersion('1.0')
    .build()

  const document = SwaggerModule.createDocument(app, options)
  SwaggerModule.setup('docs', app, document)
  await app.init()

  const expressApp = app.getHttpAdapter().getInstance()
  await app.listen(3333)
  return serverlessExpress({ app: expressApp })
}

export const handler: Handler = async (
  event: any,
  context: Context,
  callback: Callback,
) => {
  server = server ?? (await bootstrap())
  return server(event, context, callback)
}

// bootstrap()
