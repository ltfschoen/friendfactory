Role = Struct.new(:name, :display_name, :wave_type, :persona_type)

Roles = [
  Role.new('administrator', 'Administrator', 'Wave::Profile', 'Persona::Person'),
  Role.new('ambassador', 'Ambassador', 'Wave::Ambassador', 'Persona::Ambassador'),
  Role.new('user', 'User', 'Wave::Profile', 'Persona::Person')
]
