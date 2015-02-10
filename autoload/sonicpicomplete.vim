" Yanked from rubycomplete.vim
function! sonicpicomplete#Complete(findstart, base)
     "findstart = 1 when we need to get the text length
    if a:findstart
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx-1]
            if c =~ '\w'
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
        execute "ruby get_completions('" . a:base . "')"
"        if g:sonicpicomplete_completions == []
"          g:sonicpicomplete_completions = rubycomplete#Complete(findstart, base) autoload/rubycomplete.vim
"        endif
        return g:sonicpicomplete_completions
    endif
endfunction
function! s:DefRuby()
ruby << RUBYEOF
# Populate the sonicpi word list
# From server/sonicpi/lib/sonicpi/spiderapi.rb
def get_sonicpi_words
  sonicpi_words = []
  sonicpi_words += %w(at bools choose comment cue dec density dice factor?)
  sonicpi_words += %w(in_thread inc knit live_loop ndefine one_in print)
  sonicpi_words += %w(puts quantise rand rand_i range rdist ring rrand)
  sonicpi_words += %w(rrand_i rt shuffle sleep spread sync uncomment)
  sonicpi_words += %w(use_bpm use_bpm_mul use_random_seed wait with_bpm)
  sonicpi_words += %w(with_bpm_mul with_random_seed with_tempo)
  sonicpi_words += %w(define defonce)
#" From server/sonicpi/lib/sonicpi/mods/sound.rb
  sonicpi_words += %w(__freesound __freesound_path chord chord_degree)
  sonicpi_words += %w(complex_sampler_args? control degree)
  sonicpi_words += %w(fetch_or_cache_sample_path find_sample_with_path)
  sonicpi_words += %w(free_job_bus hz_to_midi job_bus job_fx_group)
  sonicpi_words += %w(job_mixer job_proms_joiner job_synth_group)
  sonicpi_words += %w(job_synth_proms_add job_synth_proms_rm)
  sonicpi_words += %w(join_thread_and_subthreads kill_fx_job_group)
  sonicpi_words += %w(kill_job_group load_sample load_samples)
  sonicpi_words += %w(load_synthdefs midi_to_hz)
  sonicpi_words += %w(normalise_and_resolve_synth_args normalise_args!)
  sonicpi_words += %w(note note_info play play_chord play_pattern)
  sonicpi_words += %w(play_pattern_timed recording_save)
  sonicpi_words += %w(resolve_sample_symbol_path rest? sample)
  sonicpi_words += %w(sample_buffer sample_duration sample_info)
  sonicpi_words += %w(sample_loaded? sample_names scale)
  sonicpi_words += %w(scale_time_args_to_bpm! set_control_delta!)
  sonicpi_words += %w(set_current_synth set_mixer_hpf!)
  sonicpi_words += %w(set_mixer_hpf_disable! set_mixer_lpf!)
  sonicpi_words += %w(set_mixer_lpf_disable! set_sched_ahead_time!)
  sonicpi_words += %w(set_volume! shutdown_job_mixer stop synth)
  sonicpi_words += %w(trigger_chord trigger_fx trigger_inst)
  sonicpi_words += %w(trigger_sampler trigger_specific_sampler)
  sonicpi_words += %w(trigger_synth trigger_synth_with_resolved_args)
  sonicpi_words += %w(use_arg_bpm_scaling use_arg_checks use_debug use_fx)
  sonicpi_words += %w(use_merged_synth_defaults use_sample_bpm)
  sonicpi_words += %w(use_sample_pack use_sample_pack_as use_synth)
  sonicpi_words += %w(use_synth_defaults use_timing_warnings)
  sonicpi_words += %w(use_transpose validate_if_necessary!)
  sonicpi_words += %w(with_arg_bpm_scaling with_arg_checks with_debug)
  sonicpi_words += %w(with_fx with_merged_synth_defaults with_sample_bpm)
  sonicpi_words += %w(with_sample_pack with_sample_pack_as with_synth)
  sonicpi_words += %w(with_synth_defaults with_timing_warnings with_transpose)
# Synths from server/sonicpi/lib/sonicpi/synthinfo.rb
  sonicpi_words += %w(:dull_bell :pretty_bell :beep :sine :saw :pulse)
  sonicpi_words += %w(:square :tri :dsaw :fm :mod_fm :mod_saw :mod_dsaw)
  sonicpi_words += %w(:mod_sine :mod_beep :mod_tri :mod_pulse :tb303)
  sonicpi_words += %w(:supersaw :prophet :zawa :dark_ambience :growl :wood)
  sonicpi_words += %w(:dark_sea_horn :singer :sound_in :noise :pnoise)
  sonicpi_words += %w(:bnoise :gnoise :cnoise)
# FX from server/sonicpi/lib/sonicpi/synthinfo.rb
  sonicpi_words += %w(:bitcrusher :reverb)
  sonicpi_words += %w(:level :echo :slicer :wobble :ixi_techno)
  sonicpi_words += %w(:compressor :rlpf :nrlpf :rhpf :nrhpf)
  sonicpi_words += %w(:hpf :nhpf :lpf :nlpf :normaliser)
  sonicpi_words += %w(:distortion :pan :bpf :nbpf :rbpf)
  sonicpi_words += %w(:nrbpf :ring :flange)
# Samples from server/sonicpi/lib/sonicpi/synthinfo.rb
  sonicpi_words += %w(:drum_heavy_kick :drum_tom_mid_soft :drum_tom_mid_hard)
  sonicpi_words += %w(:drum_tom_lo_soft :drum_tom_lo_hard :drum_tom_hi_soft)
  sonicpi_words += %w(:drum_tom_hi_hard :drum_splash_soft :drum_splash_hard)
  sonicpi_words += %w(:drum_snare_soft :drum_snare_hard :drum_cymbal_soft)
  sonicpi_words += %w(:drum_cymbal_hard :drum_cymbal_open :drum_cymbal_closed)
  sonicpi_words += %w(:drum_cymbal_pedal :drum_bass_soft :drum_bass_hard)
  sonicpi_words += %w(:elec_triangle :elec_snare :elec_lo_snare :elec_hi_snare)
  sonicpi_words += %w(:elec_mid_snare :elec_cymbal :elec_soft_kick)
  sonicpi_words += %w(:elec_filt_snare :elec_fuzz_tom :elec_chime :elec_bong)
  sonicpi_words += %w(:elec_twang :elec_wood :elec_pop :elec_beep :elec_blip)
  sonicpi_words += %w(:elec_blip2 :elec_ping :elec_bell :elec_flip :elec_tick)
  sonicpi_words += %w(:elec_hollow_kick :elec_twip :elec_plip :elec_blup)
  sonicpi_words += %w(:guit_harmonics :guit_e_fifths :guit_e_slide :guit_em9)
  sonicpi_words += %w(:misc_burp :perc_bell :perc_snap :perc_snap2)
  sonicpi_words += %w(:ambi_soft_buzz :ambi_swoosh :ambi_drone :ambi_glass_hum)
  sonicpi_words += %w(:ambi_glass_rub :ambi_haunted_hum :ambi_piano)
  sonicpi_words += %w(:ambi_lunar_land :ambi_dark_woosh :ambi_choir)
  sonicpi_words += %w(:bass_hit_c :bass_hard_c :bass_thick_c :bass_drop_c)
  sonicpi_words += %w(:bass_woodsy_c :bass_voxy_c :bass_voxy_hit_c :bass_dnb_f)
  sonicpi_words += %w(:sn_dub :sn_dolf :sn_zome :bd_ada :bd_pure :bd_808)
  sonicpi_words += %w(:bd_zum :bd_gas :bd_sone :bd_haus :bd_zome :bd_boom)
  sonicpi_words += %w(:bd_klub :bd_fat :bd_tek :loop_industrial :loop_compus)
  sonicpi_words += %w(:loop_amen :loop_amen_full :loop_garzul)
  sonicpi_words += %w(:loop_mik)
  sonicpi_words
end

def get_completions(base)
  get_sonicpi_words.grep(/#{base}/)
end
RUBYEOF
endfunction
call s:DefRuby()
