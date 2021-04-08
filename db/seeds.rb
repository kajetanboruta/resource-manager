# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
tag_category_backend = TagCategory.create(name: 'backend')
tag_category_frontend = TagCategory.create(name: 'frontend')

tag_ruby = Tag.create(name: 'ruby', tag_category_id: tag_category_backend.id)
tag_js = Tag.create(name: 'js', tag_category_id: tag_category_frontend.id)
tag_cpp = Tag.create(name: 'c++', tag_category_id: tag_category_backend.id)
tag_cs = Tag.create(name: 'c#', tag_category_id: tag_category_backend.id)
tag_python = Tag.create(name: 'python', tag_category_id: tag_category_backend.id)

