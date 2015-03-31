actions :install
default_action :install

Boolean = [TrueClass, FalseClass]

attribute :from,              kind_of: Boolean,   default: 'package'
attribute :dir,               kind_of: String,    default: '$HOME/.znc'
attribute :user,              kind_of: String,    default: 'znc', name_attribute: true
attribute :group,             kind_of: String,    default: 'znc'
attribute :port,              kind_of: String,    default: '+7777'
attribute :skin,              kind_of: String,    default: 'dark-clouds'
attribute :max_buffer_size,   kind_of: Integer,   default: 500
attribute :modules,           kind_of: Array,     default: %w[webadmin adminlog]
