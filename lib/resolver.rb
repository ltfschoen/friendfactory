class Resolver < ::ActionView::FileSystemResolver

  def initialize(prefix, root = 'app/views')
    super(root)
    @prefix = prefix
  end

  def find_templates(name, prefix, partial, details)
    super(name, @prefix, partial, details)
  end

end