<Cabbage>
form caption("MonoPlus") size(400, 350), colour(58, 58, 58), pluginid("MonoPlus")

groupbox bounds(6, 120, 101, 120) text("mod")
    checkbox bounds(8, 146, 96, 30) text("lfo mod") channel("enableLFO") radiogroup("99") value(1)
    checkbox bounds(8, 184, 96, 30) text("pitch mod") channel("enablePitch") radiogroup("99")
    
groupbox bounds(254, 120, 144, 120) text("lfo")
    rslider bounds(260, 150, 60, 60) range(0, 10, 0, 1, 0.001) text("rate") channel("rate")
    rslider bounds(332, 150, 60, 60) range(0.001, 1, 0.5, 1, 0.001) text("intensity") channel("intensity")
    hslider bounds(260, 212, 140, 20) range(4, 5, 5, 1, 1) text("lfo type") channel("LFOtype")
    
groupbox bounds(108, 120, 144, 120) text("filter")
    rslider bounds(114, 150, 60, 60) range(1, 20000, 10000, 1, 0.001) text("cutoff") channel("cutoff")
    rslider bounds(186, 150, 60, 60) range(0, 0.995, 0, 1, 0.001) text("resonance") channel("resonance")
    
groupbox bounds(6, 6, 200, 100) text("amp envelope")
    vslider bounds(14, 28, 50, 76) range(0.001, 1, 0.1, 1, 0.001) text("attack") channel("attack")
    vslider bounds(54, 28, 50, 76) range(0, 1, 0.2, 1, 0.001) text("decay") channel("decay")
    vslider bounds(94, 28, 50, 76) range(0, 1, 0.6, 1, 0.001) text("sustain") channel("sustain")
    vslider bounds(134, 28, 50, 76) range(0, 1, 0.4, 1, 0.001) text("release") channel("release")
    
keyboard bounds(8, 252, 388, 95)

label bounds(234, 10, 150, 40) text("H445")
label bounds(234, 58, 150, 16) text("MonoPlus v0.01")
</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 4
nchnls = 2
0dbfs = 1

;instrument will be triggered by keyboard widget
instr MonoPlus, 1
    iFreq = p4

    kEnv madsr chnget("attack"), chnget("decay"), chnget("sustain"), chnget("release")
        
    
    kLFO lfo chnget:k("intensity"), chnget:k("rate"), chnget:i("LFOtype")
    
    if chnget:k("enableLFO") == 1 then 
        aVco vco2 p5*kEnv, iFreq
        aLp moogladder aVco, chnget:k("cutoff")*kLFO, chnget:k("resonance")
    else
        aVco vco2 p5*kEnv, (iFreq*kLFO)+iFreq
        aLp moogladder aVco, chnget:k("cutoff"), chnget:k("resonance")
    endif
    
    outs aLp, aLp
    
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
</CsScore>
</CsoundSynthesizer>
