function! sonicpicomplete#GetContext(base)
  let s:line = getline('.')
  let s:synth_re = '\v(use_synth|synth|with_synth|set_current_synth)\s+'
  let s:fx_re = '\vwith_fx\s+'
  let s:sample_re = '\vsample\s+'

  if s:line =~ s:synth_re.':\w+\s*,\s*'
    " Synth is defined; we need the context
    let directive_end = matchend(s:line, 'synth')
    let sound = matchstr(s:line, '\v\w+', directive_end, 1)
    execute 'ruby SonicPiWordlist.get_context("'.sound.'","'.a:base.'")'
    return
  endif

  if s:line =~ s:synth_re
    " Synth is not defined; we need the synth
    execute 'ruby SonicPiWordlist.get_synths("'.a:base.'")'
    return
  endif

  if s:line =~ s:fx_re.':\w+\s*,\s*'
    " FX is defined; we need the context
    let directive_end = matchend(s:line, 'fx')
    let sound = matchstr(s:line, '\v\w+', directive_end, 1)
    execute 'ruby SonicPiWordlist.get_context("'.sound.'","'.a:base.'")'
    return
  endif

  if s:line =~ s:fx_re
    " FX is not defined; we need the FX
    execute 'ruby SonicPiWordlist.get_fx("'.a:base.'")'
    return
  endif

  if s:line =~ s:sample_re.':\w+\s*,\s*'
    " Sample is defined; we need the context
    execute 'ruby SonicPiWordlist.get_context("sample","'.a:base.'")'
    return
  endif

  if s:line =~ s:sample_re
    execute 'ruby SonicPiWordlist.get_samples("'.a:base.'")'
    return
  endif

  " Non-sound contexts
  " #spread is added in 2.4
  if s:line =~ '\vspread\s+\d+\s*,\s*\d+\s*,\s*'
    execute 'ruby SonicPiWordlist.get_context("spread","'.a:base.'")'
    return
  endif

  " If we get to this point, we're looking for directives
  execute 'ruby SonicPiWordlist.get_directives("'.a:base.'")'
endfunction

function! sonicpicomplete#Complete(findstart, base)
     "findstart = 1 when we need to get the text length
    if a:findstart
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx-1]
            if c =~ '\v[a-z0-9_:]'
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
      echom a:base
        let g:sonicpicomplete_completions = []
        call sonicpicomplete#GetContext(a:base)
        return g:sonicpicomplete_completions
    endif
endfunction
function! s:DefRuby()
ruby << RUBYEOF
class SonicPiWordlist
  attr_reader :directives, :synths, :fx, :samples, :context

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
    # New with 2.4
    @directives += %w(spread)
# Synths from server/sonicpi/lib/sonicpi/synthinfo.rb
    @synths = []
    @synths += %w(:dull_bell :pretty_bell :beep :sine :saw :pulse)
    @synths += %w(:square :tri :dsaw :fm :mod_fm :mod_saw :mod_dsaw)
    @synths += %w(:mod_sine :mod_beep :mod_tri :mod_pulse :tb303)
    @synths += %w(:supersaw :prophet :zawa :dark_ambience :growl)
    @synths += %w(:hollow :noise :pnoise)
    @synths += %w(:bnoise :gnoise :cnoise)
    # dark_sea_horn and wood have been removed in 2.4 - come back soon!
    #@synths += %w(:dark_sea_horn :wood)
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
    # Base contexts from which sound attributes are built
    @context['base_sound'] = [
      'amp', 'amp_slide', 'pan', 'pan_slide', 'attack', 'sustain', 'release'
    ]
    @context['base_pulse'] = [
      'pulse_width', 'pulse_width_slide', 'pulse_width_slide_curve', 'pulse_width_slide_shape'
    ]
    @context['base_phase'] = [
      'phase', 'phase_offset', 'phase_slide', 'phase_slide_curve', 'phase_slide_shape'
    ]
    @context['base_filter'] = [
      'cutoff', 'cutoff_slide', 'cutoff_slide_curve', 'cutoff_slide_shape'
    ]
    @context['base_res'] = [
      'res', 'res_slide', 'res_slide_curve', 'res_slide_shape'
    ]
    @context['base_detuned'] = [
      'detune', 'detune_slide', 'detune_slide_curve', 'detune_slide_shape'
    ]
    @context['base_mix'] = [
      'mix', 'mix_slide', 'mix_slide_curve', 'mix_slide_shape'
    ]
    @context['base_modulated'] = [
      'mod_invert_wave', 
      'mod_phase', 'mod_phase_offset', 'mod_phase_slide', 'mod_phase_slide_curve', 'mod_phase_slide_shape',
      'mod_pulse_width', 'mod_pulse_width_slide', 'mod_pulse_width_slide_curve', 'mod_pulse_width_slide_shape',
      'mod_range', 'mod_range_slide', 'mod_range_slide_curve', 'mod_range_slide_shape',
      'mod_wave'
    ]
    @context['base_synth'] = @context['base_sound'] + [
      'amp_slide_curve', 'amp_slide_shape',
      'attack_level',
      'decay',
      'env_curve',
      'note_slide_curve', 'note_slide_shape',
      'pan_slide_curve', 'pan_slide_shape',
      'sustain_level'
    ]
    @context['base_ambient'] = @context['base_synth'] + [
      'freq_addition', 'ring_multiplier', 'reverb_time', 'room_size'
    ]
    @context['base_fx'] = @context['base_synth'] + [
      'pre_amp', 'pre_amp_slide', 'pre_amp_slide_curve', 'pre_amp_slide_shape'
    ]

    # Synths - grouped by related base function
    @context['dull_bell'] = @context['base_synth']
    @context['pretty_bell'] = @context['dull_bell']

    @context['beep'] = @context['base_synth']
    @context['saw'] = @context['beep']
    @context['supersaw'] = @context['saw'] + @context['base_filter'] + @context['base_res']
    @context['mod_saw'] = @context['saw'] + @context['base_filter'] + @context['base_modulated']
    @context['mod_sine'] = @context['base_synth'] + @context['base_filter'] + @context['base_modulated']

    @context['square'] = @context['base_synth'] + @context['base_filter']
    @context['pulse'] = @context['square'] + @context['base_pulse']
    @context['mod_pulse'] = @context['pulse'] + @context['base_modulated']
    @context['tri'] = @context['pulse']
    @context['mod_tri'] = @context['tri'] + @context['base_modulated']

    @context['dsaw'] = @context['base_synth'] + @context['base_filter'] + @context['base_detuned']
    @context['mod_dsaw'] = @context['dsaw'] + @context['base_modulated']

    @context['fm'] = @context['base_synth'] + [
      'divisor', 'divisor_slide', 'divisor_curve', 'divisor_shape',
      'depth', 'depth_slide', 'depth_slide_curve', 'depth_slide_shape'
    ]
    @context['mod_fm'] = @context['fm'] + @context['base_modulated']

    @context['noise'] = @context['base_synth'] + @context['base_filter'] + @context['base_res']
    @context['gnoise'] = @context['noise']
    @context['bnoise'] = @context['noise']
    @context['pnoise'] = @context['noise']
    @context['cnoise'] = @context['noise']

    @context['growl'] = @context['base_synth']
    @context['dark_ambience'] = @context['base_synth'] + [
      'freq_addition', 'room_size', 'reverb_time', 'ring_multipler' #(sic)
    ]
    # dark_sea_horn has been removed in 2.4 - come back soon!
    #@context['dark_sea_horn'] = @context['base_synth']
    @context['hollow'] = @context['base_synth']
    # wood has been removed in 2.4...
    #@context['wood'] = @context['base_synth']
    @context['prophet'] = @context['base_synth'] + @context['base_filter'] + @context['base_res']
    @context['tb303'] = @context['base_synth'] + @context['base_filter'] + @context['base_pulse'] + @context['base_res']
    @context['zawa'] = @context['base_synth'] + @context['base_pulse'] + @context['base_phase'] + @context['base_modulated']

    @context['sample'] = @context['base_synth'] + @context['base_filter'] + @context['base_res'] + [
      'finish', 'rate', 'start', 'norm'
    ]
    # FX
    @context['reverb'] = @context['base_fx'] + @context['base_mix'] + [
      'room', 'room_slide', 'room_slide_curve', 'room_slide_shape',
      'damp', 'damp_slide', 'damp_slide_curve', 'damp_slide_shape'
    ]
    @context['bitcrusher'] = @context['base_fx'] + @context['base_mix'] + [
      'sample_rate', 'sample_rate_slide', 'sample_rate_slide_curve', 'sample_rate_slide_shape',
      'bits', 'bits_slide', 'bits_slide_curve', 'bits_slide_shape'
    ]
    @context['level'] = @context['base_fx'] + [
      'amp', 'amp_slide', 'amp_slide_curve', 'amp_slide_shape'
    ]
    @context['echo'] = @context['level'] + @context['base_phase'] + @context['base_mix'] + [
      'pre_amp', 'pre_amp_slide', 'pre_amp_slide_curve', 'pre_amp_slide_shape',
      'decay', 'decay_slide', 'decay_slide_curve', 'decay_slide_shape'
    ]
    @context['chorus'] = @context['echo']
    @context['flanger'] = @context['echo'] + [
      'delay', 'delay_slide', 'delay_slide_curve', 'delay_slide_shape',
      'depth', 'depth_slide', 'depth_slide_curve', 'depth_slide_shape',
      'feedback', 'feedback_slide', 'feedback_slide_curve', 'feedback_slide_shape',
      'max_delay', 'stereo_invert_wave', 'invert_flange'
    ]

    @context['slicer'] = @context['level'] + @context['base_pulse'] + @context['base_phase'] + [
      'amp_min', 'amp_min_slide', 'amp_min_slide_curve', 'amp_min_slide_shape',
      'amp_max', 'amp_max_slide', 'amp_max_slide_curve', 'amp_max_slide_shape'
    ]

    @context['ixi_techno'] = @context['level'] + @context['base_mix'] + 
        @context['base_phase'] + @context['base_res'] + [
          'cutoff_min', 'cutoff_min_slide', 'cutoff_min_slide_curve', 'cutoff_min_slide_shape',
          'cutoff_max', 'cutoff_max_slide', 'cutoff_max_slide_curve', 'cutoff_max_slide_shape'
        ]
    @context['wobble'] = @context['ixi_techno'] + @context['base_pulse']

    @context['compressor'] = @context['level'] + [
      'threshold', 'threshold_slide', 'threshold_slide_curve', 'threshold_slide_shape',
      'clamp_time', 'clamp_time_slide', 'clamp_time_slide_curve', 'clamp_time_slide_shape',
      'slope_above', 'slope_above_slide', 'slope_above_slide_curve', 'slope_above_slide_shape',
      'slope_below', 'slope_below_slide', 'slope_below_slide_curve', 'slope_below_slide_shape',
      'relax_time', 'relax_time_slide', 'relax_time_slide_curve', 'relax_time_slide_shape'
    ]

    @context['octaver'] = @context['level'] + [
      'oct1_amp', 'oct1_amp_slide', 'oct1_amp_slide_curve', 'oct1_amp_slide_shape',
      'oct1_interval', 'oct1_interval_slide', 'oct1_interval_slide_curve', 'oct1_interval_slide_shape',
      'oct2_amp', 'oct2_amp_slide', 'oct2_amp_slide_curve', 'oct2_amp_slide_shape',
      'oct3_amp', 'oct3_amp_slide', 'oct3_amp_slide_curve', 'oct3_amp_slide_shape'
    ]

    @context['ring_mod'] = @context['level'] + [
      'freq', 'freq_slide', 'freq_slide_curve', 'freq_slide_shape',
      'mod_amp', 'mod_amp_slide', 'mod_amp_slide_curve', 'mod_amp_slide_shape'
    ]

    @context['bpf'] = @context['level'] + @context['base_res'] + [
      'centre', 'centre_slide', 'centre_slide_curve', 'centre_slide_shape'
    ]
    @context['rbpf'] = @context['bpf']
    @context['nbpf'] = @context['bpf']
    @context['nrbpf'] = @context['bpf']

    @context['lpf'] = @context['level'] + @context['base_filter'] + @context['base_res'] + @context['base_mix']
    @context['rlpf'] = @context['lpf']
    @context['nlpf'] = @context['lpf']
    @context['nrlpf'] = @context['lpf']
    @context['hpf'] = @context['lpf']
    @context['nhpf'] = @context['lpf']
    @context['rhpf'] = @context['lpf']
    @context['nrhpf'] = @context['lpf']

    @context['normaliser'] = @context['level'] + [
      'level', 'level_slide', 'level_slide_curve', 'level_slide_curve_shape'
    ]

    @context['distortion'] = @context['level'] + [
      'distort', 'distort_slide', 'distort_slide_curve', 'distort_slide_shape'
    ]

    @context['pan'] = @context['level'] + [
      'pan', 'pan_slide', 'pan_slide_curve', 'pan_slide_shape'
    ]

    # Oddball helpers
    @context['spread'] = [ 'rotate' ]

  end

  def return_to_vim(completions)
    list = array2list(completions)
    VIM::command("call extend(g:sonicpicomplete_completions, [%s])" % list)
  end

  def self.get_context(sound, base)
    s = SonicPiWordlist.new
    list = s.context[sound].collect do |e|
      e.to_s + ":"
    end.sort
    if base != ''
      list = list.grep(/^#{base}/)
    end
    s.return_to_vim(list)
  end

  def self.get_synths(base)
    s = SonicPiWordlist.new
    list = s.synths.grep(/^#{base}/).sort
    s.return_to_vim(list)
  end

  def self.get_fx(base)
    s = SonicPiWordlist.new
    list = s.fx.grep(/^#{base}/).sort
    s.return_to_vim(list)
  end

  def self.get_samples(base)
    s = SonicPiWordlist.new
    list = s.samples.grep(/^#{base}/).sort
    s.return_to_vim(list)
  end

  def self.get_directives(base)
    s = SonicPiWordlist.new
    list = s.directives.grep(/^#{base}/).sort
    s.return_to_vim(list)
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
