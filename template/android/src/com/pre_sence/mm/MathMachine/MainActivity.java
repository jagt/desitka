package com.pre_sence.mm.MathMachine;

import android.os.Bundle;
import android.media.AudioManager;

public class MainActivity extends org.haxe.nme.GameActivity {
     protected void onCreate(Bundle savedInstanceState) {
         super.onCreate(savedInstanceState);
         setVolumeControlStream(AudioManager.STREAM_MUSIC);
     }
}

