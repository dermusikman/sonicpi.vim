function! sonicpicomplete#Complete(findstart, base)
     "findstart = 1 when we need to get the text length
    if a:findstart
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx-1]
            if c =~ '[0-9A-Za-z_:]'
                continue
            elseif ! c =~ '\.'
                idx = -1
                break
            else
                break
            endif
        endwhile

        return idx
    "findstart = 0 when we need to return the list of completions
    else
        let g:sonicpicomplete_completions = []
        execute "ruby SonicPiWordlist.get_completions('" . a:base . "')"
        return g:sonicpicomplete_completions
    endif
endfunction
function! s:DefRuby()
ruby << RUBYEOF
class SonicPiWordlist
  attr_reader :directives, :synths, :fx, :samples

  def initialize
# From server/sonicpi/lib/sonicpi/spiderapi.rb
    @directives = []
    @directives += %w(at bools choose comment cue dec density dice factor?)
    @directives += %w(in_thread inc knit live_loop ndefine one_in print)
    @directives += %w(puts quantise rand rand_i range rdist ring rrand)
    @directives += %w(rrand_i rt shuffle sleep spread sync uncomment)
    @directives += %w(use_bpm use_bpm_mul use_random_seed wait with_bpm)
    @directives += %w(with_bpm_mul with_random_seed with_tempo)
    @directives += %w(define defonce)
# From server/sonicpi/lib/sonicpi/mods/sound.rb
    @directives += %w(__freesound __freesound_path chord chord_degree)
    @directives += %w(complex_sampler_args? control degree)
    @directives += %w(fetch_or_cache_sample_path find_sample_with_path)
    @directives += %w(free_job_bus hz_to_midi job_bus job_fx_group)
    @directives += %w(job_mixer job_proms_joiner job_synth_group)
    @directives += %w(job_synth_proms_add job_synth_proms_rm)
    @directives += %w(join_thread_and_subthreads kill_fx_job_group)
    @directives += %w(kill_job_group load_sample load_samples)
    @directives += %w(load_synthdefs midi_to_hz)
    @directives += %w(normalise_and_resolve_synth_args normalise_args!)
    @directives += %w(note note_info play play_chord play_pattern)
    @directives += %w(play_pattern_timed recording_save)
    @directives += %w(resolve_sample_symbol_path rest? sample)
    @directives += %w(sample_buffer sample_duration sample_info)
    @directives += %w(sample_loaded? sample_names scale)
    @directives += %w(scale_time_args_to_bpm! set_control_delta!)
    @directives += %w(set_current_synth set_mixer_hpf!)
    @directives += %w(set_mixer_hpf_disable! set_mixer_lpf!)
    @directives += %w(set_mixer_lpf_disable! set_sched_ahead_time!)
    @directives += %w(set_volume! shutdown_job_mixer stop synth)
    @directives += %w(trigger_chord trigger_fx trigger_inst)
    @directives += %w(trigger_sampler trigger_specific_sampler)
    @directives += %w(trigger_synth trigger_synth_with_resolved_args)
    @directives += %w(use_arg_bpm_scaling use_arg_checks use_debug use_fx)
    @directives += %w(use_merged_synth_defaults use_sample_bpm)
    @directives += %w(use_sample_pack use_sample_pack_as use_synth)
    @directives += %w(use_synth_defaults use_timing_warnings)
    @directives += %w(use_transpose validate_if_necessary!)
    @directives += %w(with_arg_bpm_scaling with_arg_checks with_debug)
    @directives += %w(with_fx with_merged_synth_defaults with_sample_bpm)
    @directives += %w(with_sample_pack with_sample_pack_as with_synth)
    @directives += %w(with_synth_defaults with_timing_warnings with_transpose)
# Synths from server/sonicpi/lib/sonicpi/synthinfo.rb
    @synths = []
    @synths += %w(:dull_bell :pretty_bell :beep :sine :saw :pulse)
    @synths += %w(:square :tri :dsaw :fm :mod_fm :mod_saw :mod_dsaw)
    @synths += %w(:mod_sine :mod_beep :mod_tri :mod_pulse :tb303)
    @synths += %w(:supersaw :prophet :zawa :dark_ambience :growl :wood)
    @synths += %w(:dark_sea_horn :singer :sound_in :noise :pnoise)
    @synths += %w(:bnoise :gnoise :cnoise)
# FX from server/sonicpi/lib/sonicpi/synthinfo.rb
    @fx = []
    @fx += %w(:bitcrusher :reverb)
    @fx += %w(:level :echo :slicer :wobble :ixi_techno)
    @fx += %w(:compressor :rlpf :nrlpf :rhpf :nrhpf)
    @fx += %w(:hpf :nhpf :lpf :nlpf :normaliser)
    @fx += %w(:distortion :pan :bpf :nbpf :rbpf)
    @fx += %w(:nrbpf :ring :flanger)
# Samples from server/sonicpi/lib/sonicpi/synthinfo.rb
    @samples = []
    @samples += %w(:drum_heavy_kick :drum_tom_mid_soft :drum_tom_mid_hard)
    @samples += %w(:drum_tom_lo_soft :drum_tom_lo_hard :drum_tom_hi_soft)
    @samples += %w(:drum_tom_hi_hard :drum_splash_soft :drum_splash_hard)
    @samples += %w(:drum_snare_soft :drum_snare_hard :drum_cymbal_soft)
    @samples += %w(:drum_cymbal_hard :drum_cymbal_open :drum_cymbal_closed)
    @samples += %w(:drum_cymbal_pedal :drum_bass_soft :drum_bass_hard)
    @samples += %w(:elec_triangle :elec_snare :elec_lo_snare :elec_hi_snare)
    @samples += %w(:elec_mid_snare :elec_cymbal :elec_soft_kick)
    @samples += %w(:elec_filt_snare :elec_fuzz_tom :elec_chime :elec_bong)
    @samples += %w(:elec_twang :elec_wood :elec_pop :elec_beep :elec_blip)
    @samples += %w(:elec_blip2 :elec_ping :elec_bell :elec_flip :elec_tick)
    @samples += %w(:elec_hollow_kick :elec_twip :elec_plip :elec_blup)
    @samples += %w(:guit_harmonics :guit_e_fifths :guit_e_slide :guit_em9)
    @samples += %w(:misc_burp :perc_bell :perc_snap :perc_snap2)
    @samples += %w(:ambi_soft_buzz :ambi_swoosh :ambi_drone :ambi_glass_hum)
    @samples += %w(:ambi_glass_rub :ambi_haunted_hum :ambi_piano)
    @samples += %w(:ambi_lunar_land :ambi_dark_woosh :ambi_choir)
    @samples += %w(:bass_hit_c :bass_hard_c :bass_thick_c :bass_drop_c)
    @samples += %w(:bass_woodsy_c :bass_voxy_c :bass_voxy_hit_c :bass_dnb_f)
    @samples += %w(:sn_dub :sn_dolf :sn_zome :bd_ada :bd_pure :bd_808)
    @samples += %w(:bd_zum :bd_gas :bd_sone :bd_haus :bd_zome :bd_boom)
    @samples += %w(:bd_klub :bd_fat :bd_tek :loop_industrial :loop_compus)
    @samples += %w(:loop_amen :loop_amen_full :loop_garzul)
    @samples += %w(:loop_mik)

# Contexts in which we may want particular completions
    @context = {}
# Synths from server/sonicpi/lib/sonicpi/synthinfo.rb
    @context[:base_sound] = [
      :amp, :amp_slide, :pan, :pan_slide, :attack, :sustain, :release
    ]
    @context[:base_pulse] = [
      :pulse_width, :pulse_width_slide, :pulse_width_slide_curve, :pulse_width_slide_shape
    ]
    @context[:base_phase] = [
      :phase, :phase_offset, :phase_slide, :phase_slide_curve, :phase_slide_shape
    ]
    @context[:base_filter] = [
      :cutoff, :cutoff_slide, :cutoff_slide_curve, :cutoff_slide_shape
    ]
    @context[:base_res] = [
      :res, :res_slide, :res_slide_curve, :res_slide_shape
    ]
    @context[:base_detuned] = [
      :detune, :detune_slide, :detune_slide_curve, :detune_slide_shape
    ]
    @context[:base_modulated] = [
      :mod_invert_wave, 
      :mod_phase, :mod_phase_offset, :mod_phase_slide, :mod_phase_slide_curve, :mod_phase_slide_shape,
      :mod_pulse_width, :mod_pulse_width_slide, :mod_pulse_width_slide_curve, :mod_pulse_width_slide_shape,
      :mod_range, :mod_range_slide, :mod_range_slide_curve, :mod_range_slide_shape,
      :mod_wave
    ]
    @context[:base_synth] = @context[:base_sound] + [
      :amp_slide_curve, :amp_slide_shape,
      :attack_level,
      :decay,
      :env_curve,
      :note_slide_curve, :note_slide_shape,
      :pan_slide_curve, :pan_slide_shape,
      :sustain_level
    ]
    @context[:base_ambient] = @context[:base_synth] + [
      :freq_addition, :ring_multiplier, :reverb_time, :room_size
    ]
    @context[:fm] = @context[:base_synth] + [
      :divisor, :divisor_slide, :divisor_curve, :divisor_shape,
      :depth, :depth_slide, :depth_slide_curve, :depth_slide_shape
    ]
    @context[:noise] = @context[:base_synth] + @context[:base_filter] + @context[:base_res]
    @context[:sample] = @context[:base_synth] + [
      :finish, :rate, :start
    ]
    @context[:prophet] = @context[:base_synth] + @context[:base_filter] + @context[:base_res]
    @context[:zawa] = @context[:base_synth] + @context[:base_pulse] + @context[:base_phase] + @context[:base_modulated]
# XXX Next up: FX
  end

  def self.get_completions(base)
    SonicPiWordlist.new.get_completions base
  end

  def get_completions(base)
    completions = []
    completions += @directives.grep(/^#{base}/)
    completions += @synths.grep(/^#{base}/)
    completions += @fx.grep(/^#{base}/)
    completions += @samples.grep(/^#{base}/)
    list = array2list(completions)
    VIM::command("call extend(g:sonicpicomplete_completions, [%s])" % list)
  end

  def self.get_synths(base)
    list = array2list(SonicPiWordlist.new.synths.grep(/^#{base}/))
    list
  end

  def self.get_fx(base)
    list = array2list(SonicPiWordlist.new.fx.grep(/^#{base}/))
    list
  end

  def self.get_samples(base)
    list = array2list(SonicPiWordlist.new.samples.grep(/^#{base}/))
    list
  end

  def self.get_directives(base)
    list = array2list(SonicPiWordlist.new.directives.grep(/^#{base}/))
    list
  end

  private
  def array2list(array)
    list = array.join('","')
    list.gsub!(/^(.)/, '"\1')
    list.gsub!(/(.)$/, '\1"')
    list
  end
end
RUBYEOF
endfunction
call s:DefRuby()
