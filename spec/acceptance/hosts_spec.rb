require 'spec_helper_acceptance'

describe 'hosts' do
  context 'with default values for class parameters' do
    pp = <<-EOS
      include hosts
    EOS

    it 'works without errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'with a host specified' do
    pp = <<-EOS
      $hosts = {
        'test' => {
          ensure       => present,
          host_aliases => ['test.example.com'],
          ip           => '10.1.2.3',
        }
      }

      class { 'hosts':
        hosts => $hosts,
      }
    EOS

    it 'works without errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(pp, catch_changes: true)
    end

    describe host('test.example.com') do
      it { is_expected.to be_resolvable.by('hosts') }
    end
  end
end
