require 'spec_helper_acceptance'

describe 'hosts' do
  context 'default' do
      pp = <<-EOS
      include ::hosts
      EOS

    it 'should work without errors' do
      apply_manifest(pp, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
