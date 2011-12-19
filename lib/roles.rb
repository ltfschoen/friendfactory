Role = Struct.new(:name, :display_name, :wave_type)

Roles = [
  Role.new('administrator', 'Administrator', 'Wave::Profile'),
  Role.new('ambassador', 'Ambassador', 'Wave::Ambassador'),
  Role.new('user', 'User', 'Wave::Profile')
]
