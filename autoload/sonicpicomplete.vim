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

    # The synths
    @synths = []
    @context = {}
    @synths += ':dull_bell'
    @context['dull_bell'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2}
    @synths += ':pretty_bell'
    @context['pretty_bell'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2}
    @synths += ':beep'
    @context['beep'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2}
    @synths += ':sine'
    @context['sine'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2}
    @synths += ':saw'
    @context['saw'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2}
    @synths += ':pulse'
    @context['pulse'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0}
    @synths += ':subpulse'
    @context['subpulse'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0, :sub_amp=>1, :sub_amp_slide=>0, :sub_amp_slide_shape=>1, :sub_amp_slide_curve=>0, :sub_detune=>-12, :sub_detune_slide=>0, :sub_detune_slide_shape=>1, :sub_detune_slide_curve=>0}
    @synths += ':square'
    @context['square'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0}
    @synths += ':tri'
    @context['tri'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0}
    @synths += ':dsaw'
    @context['dsaw'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :detune=>0.1, :detune_slide=>0, :detune_slide_shape=>1, :detune_slide_curve=>0}
    @synths += ':dpulse'
    @context['dpulse'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :detune=>0.1, :detune_slide=>0, :detune_slide_shape=>1, :detune_slide_curve=>0, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0, :dpulse_width=>0.5, :dpulse_width_slide=>0, :dpulse_width_slide_shape=>1, :dpulse_width_slide_curve=>0}
    @synths += ':dtri'
    @context['dtri'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :detune=>0.1, :detune_slide=>0, :detune_slide_shape=>1, :detune_slide_curve=>0}
    @synths += ':fm'
    @context['fm'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :divisor=>2, :divisor_slide=>0, :divisor_slide_shape=>1, :divisor_slide_curve=>0, :depth=>1, :depth_slide=>0, :depth_slide_shape=>1, :depth_slide_curve=>0}
    @synths += ':mod_fm'
    @context['mod_fm'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :divisor=>2, :divisor_slide=>0, :divisor_slide_shape=>1, :divisor_slide_curve=>0, :depth=>1, :depth_slide=>0, :depth_slide_shape=>1, :depth_slide_curve=>0, :mod_phase=>0.25, :mod_range=>5, :mod_pulse_width=>0.5, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1}
    @synths += ':mod_saw'
    @context['mod_saw'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :mod_phase=>0.25, :mod_phase_slide=>0, :mod_phase_slide_shape=>1, :mod_phase_slide_curve=>0, :mod_range=>5, :mod_range_slide=>0, :mod_range_slide_shape=>1, :mod_range_slide_curve=>0, :mod_pulse_width=>0.5, :mod_pulse_width_slide=>0, :mod_pulse_width_slide_shape=>1, :mod_pulse_width_slide_curve=>0, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1}
    @synths += ':mod_dsaw'
    @context['mod_dsaw'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :mod_phase=>0.25, :mod_phase_slide=>0, :mod_phase_slide_shape=>1, :mod_phase_slide_curve=>0, :mod_range=>5, :mod_range_slide=>0, :mod_range_slide_shape=>1, :mod_range_slide_curve=>0, :mod_pulse_width=>0.5, :mod_pulse_width_slide=>0, :mod_pulse_width_slide_shape=>1, :mod_pulse_width_slide_curve=>0, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1, :detune=>0.1, :detune_slide=>0, :detune_slide_shape=>1, :detune_slide_curve=>0}
    @synths += ':mod_sine'
    @context['mod_sine'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :mod_phase=>0.25, :mod_phase_slide=>0, :mod_phase_slide_shape=>1, :mod_phase_slide_curve=>0, :mod_range=>5, :mod_range_slide=>0, :mod_range_slide_shape=>1, :mod_range_slide_curve=>0, :mod_pulse_width=>0.5, :mod_pulse_width_slide=>0, :mod_pulse_width_slide_shape=>1, :mod_pulse_width_slide_curve=>0, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1}
    @synths += ':mod_beep'
    @context['mod_beep'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :mod_phase=>0.25, :mod_phase_slide=>0, :mod_phase_slide_shape=>1, :mod_phase_slide_curve=>0, :mod_range=>5, :mod_range_slide=>0, :mod_range_slide_shape=>1, :mod_range_slide_curve=>0, :mod_pulse_width=>0.5, :mod_pulse_width_slide=>0, :mod_pulse_width_slide_shape=>1, :mod_pulse_width_slide_curve=>0, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1}
    @synths += ':mod_tri'
    @context['mod_tri'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :mod_phase=>0.25, :mod_phase_slide=>0, :mod_phase_slide_shape=>1, :mod_phase_slide_curve=>0, :mod_range=>5, :mod_range_slide=>0, :mod_range_slide_shape=>1, :mod_range_slide_curve=>0, :mod_pulse_width=>0.5, :mod_pulse_width_slide=>0, :mod_pulse_width_slide_shape=>1, :mod_pulse_width_slide_curve=>0, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1}
    @synths += ':mod_pulse'
    @context['mod_pulse'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :mod_phase=>0.25, :mod_phase_slide=>0, :mod_phase_slide_shape=>1, :mod_phase_slide_curve=>0, :mod_range=>5, :mod_range_slide=>0, :mod_range_slide_shape=>1, :mod_range_slide_curve=>0, :mod_pulse_width=>0.5, :mod_pulse_width_slide=>0, :mod_pulse_width_slide_shape=>1, :mod_pulse_width_slide_curve=>0, :mod_phase_offset=>0, :mod_invert_wave=>0, :mod_wave=>1, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0}
    @synths += ':chiplead'
    @context['chiplead'] = {:note=>60, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :note_resolution=>0.1, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :width=>0}
    @synths += ':chipbass'
    @context['chipbass'] = {:note=>60, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :note_resolution=>0.1, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2}
    @synths += ':tb303'
    @context['tb303'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>120, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :cutoff_min=>30, :cutoff_min_slide=>0, :cutoff_min_slide_shape=>1, :cutoff_min_slide_curve=>0, :cutoff_attack=>0, :cutoff_decay=>0, :cutoff_sustain=>0, :cutoff_release=>1, :cutoff_attack_level=>1, :cutoff_decay_level=>1, :cutoff_sustain_level=>1, :res=>0.9, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0, :wave=>0, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0}
    @synths += ':supersaw'
    @context['supersaw'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>130, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.7, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':hoover'
    @context['hoover'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0.05, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>130, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.1, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':prophet'
    @context['prophet'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.7, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':zawa'
    @context['zawa'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.9, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0, :phase=>1, :phase_slide=>0, :phase_slide_shape=>1, :phase_slide_curve=>0, :phase_offset=>0, :wave=>3, :invert_wave=>0, :range=>24, :range_slide=>0, :range_slide_shape=>1, :range_slide_curve=>0, :disable_wave=>0, :pulse_width=>0.5, :pulse_width_slide=>0, :pulse_width_slide_shape=>1, :pulse_width_slide_curve=>0}
    @synths += ':dark_ambience'
    @context['dark_ambience'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.7, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0, :detune1=>12, :detune1_slide=>0, :detune1_slide_shape=>1, :detune1_slide_curve=>0, :detune2=>24, :detune2_slide=>0, :detune2_slide_shape=>1, :detune2_slide_curve=>0, :noise=>0, :ring=>0.2, :room=>70, :reverb_time=>100}
    @synths += ':growl'
    @context['growl'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0.1, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>130, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.7, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':hollow'
    @context['hollow'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>90, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.99, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0, :noise=>1, :norm=>0}
    @synths += ':blade'
    @context['blade'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>100, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :vibrato_rate=>6, :vibrato_rate_slide_shape=>1, :vibrato_rate_slide_curve=>0, :vibrato_depth=>0.15, :vibrato_depth_slide_shape=>1, :vibrato_depth_slide_curve=>0, :vibrato_delay=>0.5, :vibrato_onset=>0.1}
    @synths += ':piano'
    @context['piano'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :vel=>0.2, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :hard=>0.5, :stereo_width=>0}
    @synths += ':pluck'
    @context['pluck'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay=>0, :decay_level=>1, :sustain_level=>1, :noise_amp=>0.8, :max_delay_time=>0.125, :pluck_decay=>30, :coef=>0.3}
    @synths += ':tech_saws'
    @context['tech_saws'] = {:note=>52, :note_slide=>0, :note_slide_shape=>1, :note_slide_curve=>0, :amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>130, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0.7, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':sound_in'
    @context['sound_in'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>1, :release=>0, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>0, :input=>1}
    @synths += ':sound_in_stereo'
    @context['sound_in_stereo'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>1, :release=>0, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>0, :input=>1}
    @synths += ':noise'
    @context['noise'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':pnoise'
    @context['pnoise'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':bnoise'
    @context['bnoise'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':gnoise'
    @context['gnoise'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':cnoise'
    @context['cnoise'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>1, :amp_slide_curve=>0, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>0, :release=>1, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>2, :cutoff=>110, :cutoff_slide=>0, :cutoff_slide_shape=>1, :cutoff_slide_curve=>0, :res=>0, :res_slide=>0, :res_slide_shape=>1, :res_slide_curve=>0}
    @synths += ':chipnoise'
    @context['chipnoise'] = {:amp=>1, :amp_slide=>0, :amp_slide_shape=>0, :amp_slide_curve=>1, :pan=>0, :pan_slide=>0, :pan_slide_shape=>1, :pan_slide_curve=>0, :attack=>0, :decay=>0, :sustain=>1, :release=>0, :attack_level=>1, :decay_level=>1, :sustain_level=>1, :env_curve=>0, :freq_band=>0, :freq_band_slide=>0, :freq_band_slide_shape=>1, :freq_band_slide_curve=>0}

    # The samples
    @samples = [":drum_heavy_kick", ":drum_tom_mid_soft", ":drum_tom_mid_hard", ":drum_tom_lo_soft", ":drum_tom_lo_hard", ":drum_tom_hi_soft", ":drum_tom_hi_hard", ":drum_splash_soft", ":drum_splash_hard", ":drum_snare_soft", ":drum_snare_hard", ":drum_cymbal_soft", ":drum_cymbal_hard", ":drum_cymbal_open", ":drum_cymbal_closed", ":drum_cymbal_pedal", ":drum_bass_soft", ":drum_bass_hard", ":drum_cowbell", ":drum_roll", ":elec_triangle", ":elec_snare", ":elec_lo_snare", ":elec_hi_snare", ":elec_mid_snare", ":elec_cymbal", ":elec_soft_kick", ":elec_filt_snare", ":elec_fuzz_tom", ":elec_chime", ":elec_bong", ":elec_twang", ":elec_wood", ":elec_pop", ":elec_beep", ":elec_blip", ":elec_blip2", ":elec_ping", ":elec_bell", ":elec_flip", ":elec_tick", ":elec_hollow_kick", ":elec_twip", ":elec_plip", ":elec_blup", ":guit_harmonics", ":guit_e_fifths", ":guit_e_slide", ":guit_em9", ":misc_burp", ":misc_crow", ":misc_cineboom", ":perc_bell", ":perc_snap", ":perc_snap2", ":perc_swash", ":perc_till", ":ambi_soft_buzz", ":ambi_swoosh", ":ambi_drone", ":ambi_glass_hum", ":ambi_glass_rub", ":ambi_haunted_hum", ":ambi_piano", ":ambi_lunar_land", ":ambi_dark_woosh", ":ambi_choir", ":bass_hit_c", ":bass_hard_c", ":bass_thick_c", ":bass_drop_c", ":bass_woodsy_c", ":bass_voxy_c", ":bass_voxy_hit_c", ":bass_dnb_f", ":sn_dub", ":sn_dolf", ":sn_zome", ":bd_ada", ":bd_pure", ":bd_808", ":bd_zum", ":bd_gas", ":bd_sone", ":bd_haus", ":bd_zome", ":bd_boom", ":bd_klub", ":bd_fat", ":bd_tek", ":loop_industrial", ":loop_compus", ":loop_amen", ":loop_amen_full", ":loop_garzul", ":loop_mika", ":loop_breakbeat", ":loop_safari", ":loop_tabla", ":tabla_tas1", ":tabla_tas2", ":tabla_tas3", ":tabla_ke1", ":tabla_ke2", ":tabla_ke3", ":tabla_na", ":tabla_na_o", ":tabla_tun1", ":tabla_tun2", ":tabla_tun3", ":tabla_te1", ":tabla_te2", ":tabla_te_ne", ":tabla_te_m", ":tabla_ghe1", ":tabla_ghe2", ":tabla_ghe3", ":tabla_ghe4", ":tabla_ghe5", ":tabla_ghe6", ":tabla_ghe7", ":tabla_ghe8", ":tabla_dhec", ":tabla_na_s", ":tabla_re", ":vinyl_backspin", ":vinyl_rewind", ":vinyl_scratch", ":vinyl_hiss"]

    # The FX
    @fx = [":bitcrusher", ":krush", ":reverb", ":gverb", ":level", ":mono", ":echo", ":slicer", ":panslicer", ":wobble", ":ixi_techno", ":compressor", ":whammy", ":rlpf", ":nrlpf", ":rhpf", ":nrhpf", ":hpf", ":nhpf", ":lpf", ":nlpf", ":normaliser", ":distortion", ":pan", ":bpf", ":nbpf", ":rbpf", ":nrbpf", ":band_eq", ":tanh", ":pitch_shift", ":ring_mod", ":octaver", ":vowel", ":flanger", ":eq", ":tremolo", ":record", ":sound_out", ":sound_out_stereo"]

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
