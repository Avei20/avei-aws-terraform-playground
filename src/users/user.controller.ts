import {
  Body,
  Controller,
  Delete,
  Get,
  HttpException,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common'
import { UserService } from './user.service'
import { CreateUserDTO } from './dto/createUser.dto'
import { UpdateUserDTO } from './dto/updateUser.dto'
import { ApiQuery } from '@nestjs/swagger'

@Controller('users')
export class UserController {
  constructor(private userService: UserService) {}

  @Get()
  @ApiQuery({ name: 'pages', required: true })
  @ApiQuery({ name: 'limit', required: true })
  async getAllUserPaginate(@Query() query: { pages?: number; limit?: number }) {
    const { pages, limit } = query
    // const users = await this.userService.findAllPaginate(pages, limit)

    return this.userService.findAllPaginate(pages, limit)
  }

  @Get('seed')
  async seedingDB() {
    return await this.userService.seed()
  }

  @Get(':id')
  async getById(@Param('id') id: number) {
    const user = await this.userService.findOne(id)

    if (!user) throw new NotFoundException()

    return {
      data: user,
    }
  }

  @Post()
  async createUser(@Body() userDTO: CreateUserDTO) {
    return {
      data: {
        ...(await this.userService.create({
          firstName: userDTO.firstName,
          lastName: userDTO.lastName,
          email: userDTO.email,
        })),
        createdAt: new Date(),
      },
    }
  }

  @Put(':id')
  async updateUser(
    @Param('id') id: number,
    @Body() updateUserDTO: UpdateUserDTO,
  ) {
    const user = await this.userService.findOne(id)

    if (!user) throw new NotFoundException()

    return {
      data: {
        ...(await this.userService.update(id, {
          firstName: updateUserDTO.firstName
            ? updateUserDTO.firstName
            : user.firstName,
          lastName: updateUserDTO.lastName
            ? updateUserDTO.lastName
            : user.lastName,
          email: updateUserDTO.email ? updateUserDTO.email : user.email,
          id: user.id,
        })),
        updateAt: new Date(),
      },
    }
  }

  @Delete(':id')
  async deleteUser(@Param('id') id: number) {
    const user = await this.userService.remove(id)
    if (user) throw new HttpException({}, HttpStatus.NOT_FOUND)
    else throw new NotFoundException()
  }
}
