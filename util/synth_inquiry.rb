# We should probably find the SynthInfo class relatively
#  Presently assumes we're in <sonic-pi-path>/server/sonicpi/lib/sonicpi
require './synths/synthinfo'

fp = File.open("/tmp/sonic-pi-synths-for-vim.rb", "w")

fp.puts "# The synths"
fp.puts "@synths = []"
fp.puts "@context = {}"
SonicPi::Synths::SynthInfo.all_synths.each do |synth|
  fp.puts "@synths += ':#{synth.to_s}'"
  fp.print "@context['#{synth.to_s}'] = "  # We're printing to save the \n
  args = SonicPi::Synths::SynthInfo.get_info(synth).arg_defaults
  args.select {|k,v| v.is_a? Symbol}
    .each do |k,v|
      # e.g., {decay_level: :sustain_level} -> {decay_level: args[:sustain_level]}
      args[k] = args[v]
    end
  fp.puts args
end

fp.puts "# The samples"
fp.print "@samples = "
fp.puts SonicPi::Synths::SynthInfo.all_samples.map {|s| ":#{s.to_s}"}.to_s

#fx = SonicPi::Synths::SynthInfo.all_fx
fp.puts "# The FX"
fp.print "@fx = "
fp.puts SonicPi::Synths::SynthInfo.all_fx.map {|f| ":#{f.to_s}"}.to_s

fp.close
