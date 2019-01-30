package com.zivost.musickit;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** MusickitPlugin */
public class MusickitPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "musickit");
    channel.setMethodCallHandler(new MusickitPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      result.notImplemented();
  }
}
