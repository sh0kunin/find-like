RSpec.describe FindLike do
  it 'has a version number' do
    expect(FindLike::VERSION).not_to be nil
  end

  it 'test path is parsed' do
    argv = CLAide::ARGV.new(['--path=.'])
    command = FindLike::Command.new(argv)
    expect(command.path).to eq(".")
  end

  it 'test name is parsed' do
    argv = CLAide::ARGV.new(['--path=.', '--name=*.txt'])
    command = FindLike::Command.new(argv)
    expect(command.name).to eq("*.txt")
  end

  it 'test rname is parsed' do
    argv = CLAide::ARGV.new(['--path=.', '--name=*.txt', '--rname=/find/'])
    command = FindLike::Command.new(argv)
    expect(command.rname).to eq("/find/")
  end

  it 'test rname is parsed' do
    argv = CLAide::ARGV.new(['--path=.', '--name=*.txt', '--rname=/find/'])
    command = FindLike::Command.new(argv)
    expect(command.rname).to eq("/find/")
  end

  it 'test --L flag is parsed' do
    argv = CLAide::ARGV.new(['--L',' --path=.', '--name=*.txt', '--rname=/find/'])
    command = FindLike::Command.new(argv)
    expect(command.l).to eq(true)
    expect(command.p).to eq(false)
  end

  it 'test type is parsed properly' do
    argv = CLAide::ARGV.new(['--path=.', '--name=*.txt', '--rname=/find/', '--type=d'])
    command = FindLike::Command.new(argv)
    expect(command.type).to eq('d')
    command.validate!
    expect(command.type).to eq('directory')
  end

  it 'test if path not supplied it shows error is raised' do
    argv = CLAide::ARGV.new([])
    command = FindLike::Command.new(argv)
    expect { command.validate!}.to raise_error()
  end

  it 'validate if ftype i' do
    argv = CLAide::ARGV.new(['--L','--path=.', '--type=s'])
    command = FindLike::Command.new(argv)
    expect { command.validate!}.to raise_error()
  end
end
