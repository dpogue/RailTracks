# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

User.create!(:username => 'admin',
             :email => 'admin@example.com',
             :password => 'RT_admin',
             :password_confirmation => 'RT_admin',
             :admin => true)
