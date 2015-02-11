"if exists("b:current_syntax")
"  finish
"endif

" Import and extend Ruby syntax
"  see :help :syn-include
":runtime! syntax/ruby.vim
"syntax include @rubyNotTop syntax/ruby.vim
" syntax cluster SonicPi contains=@rubyNotTop

" From server/sonicpi/lib/sonicpi/spiderapi.rb
syntax keyword sonicpiKeyword at bools choose comment cue dec density dice factor? 
syntax keyword sonicpiKeyword in_thread inc knit live_loop ndefine one_in print 
syntax keyword sonicpiKeyword puts quantise rand rand_i range rdist ring rrand 
syntax keyword sonicpiKeyword rrand_i rt shuffle sleep spread sync uncomment 
syntax keyword sonicpiKeyword use_bpm use_bpm_mul use_random_seed wait with_bpm 
syntax keyword sonicpiKeyword with_bpm_mul with_random_seed with_tempo 
syntax keyword rubyDefine define defonce
" From server/sonicpi/lib/sonicpi/mods/sound.rb
syntax keyword sonicpiKeyword __freesound __freesound_path chord chord_degree 
syntax keyword sonicpiKeyword complex_sampler_args? control degree 
syntax keyword sonicpiKeyword fetch_or_cache_sample_path find_sample_with_path 
syntax keyword sonicpiKeyword free_job_bus hz_to_midi job_bus job_fx_group 
syntax keyword sonicpiKeyword job_mixer job_proms_joiner job_synth_group 
syntax keyword sonicpiKeyword job_synth_proms_add job_synth_proms_rm 
syntax keyword sonicpiKeyword join_thread_and_subthreads kill_fx_job_group 
syntax keyword sonicpiKeyword kill_job_group load_sample load_samples 
syntax keyword sonicpiKeyword load_synthdefs midi_to_hz 
syntax keyword sonicpiKeyword normalise_and_resolve_synth_args normalise_args! 
syntax keyword sonicpiKeyword note note_info play play_chord play_pattern 
syntax keyword sonicpiKeyword play_pattern_timed recording_save 
syntax keyword sonicpiKeyword resolve_sample_symbol_path rest? sample
syntax keyword sonicpiKeyword sample_buffer sample_duration sample_info
syntax keyword sonicpiKeyword sample_loaded? sample_names scale 
syntax keyword sonicpiKeyword scale_time_args_to_bpm! set_control_delta! 
syntax keyword sonicpiKeyword set_current_synth set_mixer_hpf! 
syntax keyword sonicpiKeyword set_mixer_hpf_disable! set_mixer_lpf! 
syntax keyword sonicpiKeyword set_mixer_lpf_disable! set_sched_ahead_time! 
syntax keyword sonicpiKeyword set_volume! shutdown_job_mixer stop synth 
syntax keyword sonicpiKeyword trigger_chord trigger_fx trigger_inst 
syntax keyword sonicpiKeyword trigger_sampler trigger_specific_sampler 
syntax keyword sonicpiKeyword trigger_synth trigger_synth_with_resolved_args 
syntax keyword sonicpiKeyword use_arg_bpm_scaling use_arg_checks use_debug use_fx 
syntax keyword sonicpiKeyword use_merged_synth_defaults use_sample_bpm 
syntax keyword sonicpiKeyword use_sample_pack use_sample_pack_as use_synth 
syntax keyword sonicpiKeyword use_synth_defaults use_timing_warnings 
syntax keyword sonicpiKeyword use_transpose validate_if_necessary! 
syntax keyword sonicpiKeyword with_arg_bpm_scaling with_arg_checks with_debug 
syntax keyword sonicpiKeyword with_fx with_merged_synth_defaults with_sample_bpm 
syntax keyword sonicpiKeyword with_sample_pack with_sample_pack_as with_synth 
syntax keyword sonicpiKeyword with_synth_defaults with_timing_warnings with_transpose 

highlight link sonicpiKeyword Keyword
highlight link sonicpiDefine Function

":unlet b:current_syntax
