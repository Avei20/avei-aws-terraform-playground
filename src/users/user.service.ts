import { InjectRepository } from '@nestjs/typeorm'
import { User } from './user.entity'
import { Repository } from 'typeorm'
import { CreateUserDTO } from './dto/createUser.dto'
import { userData } from 'src/database/data/user'
import { Logger } from '@nestjs/common'

export class UserService {
  private logger: Logger = new Logger(UserService.name)

  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  findAll(): Promise<User[]> {
    return this.userRepository.find()
  }

  async findAllPaginate(page: number, limit: number = 5): Promise<any> {
    page = page - 1
    const [data, total] = await this.userRepository.findAndCount({
      skip: page * limit,
      take: limit,
    })

    const totalPages = Math.ceil(total / limit)

    return {
      page,
      per_page: limit,
      total,
      total_pages: totalPages,
      data,
    }
  }

  findOne(id: number): Promise<User | null> {
    return this.userRepository.findOneBy({ id })
  }

  async remove(id: number): Promise<User> {
    const user = this.findOne(id)
    await this.userRepository.delete(id)
    return user
  }

  async create(userDTO: CreateUserDTO): Promise<User> {
    const user = new User()
    user.firstName = userDTO.firstName
    user.lastName = userDTO.lastName
    user.email = userDTO.email

    return this.userRepository.save(user)
  }

  async update(id: number, user: User): Promise<User> {
    await this.userRepository.update(id, user)
    return this.userRepository.findOneBy({ id })
  }

  async seed(): Promise<any> {
    const userList: Partial<User>[] = userData
    try {
      await this.userRepository.save(userList)
      this.logger.log('Seeding user data completed')
      return 'seeding completed'
    } catch (error) {
      this.logger.error('Seeding user data failed')
      return { error }
    }
  }
}
