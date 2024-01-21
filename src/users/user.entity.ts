import { Column, Entity, PrimaryGeneratedColumn, Unique } from 'typeorm'

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number

  @Column()
  @Unique(['email'])
  email: string

  @Column()
  firstName: string

  @Column()
  lastName: string

  @Column({ nullable: true })
  avatar?: string
}
