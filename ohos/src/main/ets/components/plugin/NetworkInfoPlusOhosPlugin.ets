import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import MethodChannel, {
  MethodCallHandler,
  MethodResult
} from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel';
import MethodCall from '@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall';
import wifiManager from '@ohos.wifiManager';

/** NetworkInfoPlusOhosPlugin **/
export default class NetworkInfoPlusOhosPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "NetworkInfoPlusOhosPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "dev.fluttercommunity.plus/network_info");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {

    if (!wifiManager.isWifiActive()) {
      result.success(null);
      return;
    }
    let wifiInfo = await wifiManager.getLinkedInfo();
    if (wifiInfo == undefined) {
      result.success(null);
      return;
    }

    if (call.method == "wifiName") {
      result.success(wifiInfo.ssid)
    }
    else if (call.method == "wifiBSSID") {
      result.success(wifiInfo.bssid)
    }
    else if (call.method == "wifiIPAddress") {
      let ipInfo = await wifiManager.getIpInfo();
      if (ipInfo != undefined && ipInfo.ipAddress == wifiInfo.ipAddress) {
        result.success(this.wifiNumberToIp(ipInfo.ipAddress))
      }
      else {
        result.success(null);
      }
    }
    else if (call.method == "wifiIPv6Address") {
      let ipv6Info: wifiManager.Ipv6Info = await wifiManager.getIpv6Info();
      if (ipv6Info != undefined) {

        let json= JSON.stringify(ipv6Info);
        let fixedIpv6Info = JSON.parse(json) as FixedIpv6Info;

        let address = fixedIpv6Info.linkIpV6Address;
        if (address == undefined || address == '') {
          address = fixedIpv6Info.globalIpV6Address;
        }
        if (address == undefined || address == '') {
          address = fixedIpv6Info.randGlobalIpV6Address;
        }
        result.success(address)
      }
      else {
        result.success(null);
      }
    }
    else if (call.method == "wifiSubmask") {
      let ipInfo = await wifiManager.getIpInfo();
      if (ipInfo != undefined && ipInfo.ipAddress == wifiInfo.ipAddress) {
        result.success(this.wifiNumberToIp(ipInfo.netmask));
      }
      else {
        let ipv6Info = await wifiManager.getIpv6Info();
        if (ipv6Info != undefined) {
          result.success(ipv6Info.netmask)
        }
        else {
          result.success(null);
        }
      }
    } else if (call.method == "wifiGatewayAddress") {
      let ipInfo = await wifiManager.getIpInfo();
      if (ipInfo != undefined && ipInfo.ipAddress == wifiInfo.ipAddress) {
        result.success(this.wifiNumberToIp(ipInfo.gateway));
      }
      else {
        let ipv6Info = await wifiManager.getIpv6Info();
        if (ipv6Info != undefined) {
          result.success(ipv6Info.gateway)
        }
        else {
          result.success(null);
        }
      }
    } else if (call.method == "wifiBroadcast") {
      let ipInfo = await wifiManager.getIpInfo();
      if (ipInfo != undefined && ipInfo.ipAddress == wifiInfo.ipAddress) {
        result.success(this.calculateBroadcastAddress(this.wifiNumberToIp(ipInfo.ipAddress), this.wifiNumberToIp(ipInfo.netmask)))
      }
      else {
        result.success(null);
      }

    }
    else {
      result.notImplemented()
    }
  }

  wifiNumberToIp(wifiNumber: number): string {
    const octet1 = (wifiNumber >> 24) & 0xFF;
    const octet2 = (wifiNumber >> 16) & 0xFF;
    const octet3 = (wifiNumber >> 8) & 0xFF;
    const octet4 = wifiNumber & 0xFF;
    return `${octet1}.${octet2}.${octet3}.${octet4}`;
  }

  calculateBroadcastAddress(ipAddress: string, subnetMask: string): string {
    const ipParts = ipAddress.split('.').map(Number);
    const maskParts = subnetMask.split('.').map(Number);

    const invertedMaskParts = maskParts.map(part => 255 - part);

    const broadcastParts = ipParts.map((part, index) => (part | invertedMaskParts[index]));

    return broadcastParts.join('.');
  }
}

interface FixedIpv6Info {
  /**
   * The link IPv6 address of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  linkIpV6Address: string;
  /**
   * The global IPv6 address of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  globalIpV6Address: string;
  /**
   * The rand Global IPv6 address of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  randGlobalIpV6Address: string;
  /**
   * The gateway of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  gateway: string;
  /**
   * The network mask of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  netmask: string;
  /**
   * The primary DNS server IPV6 address of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  primaryDNS: string;
  /**
   * The secondary DNS server IPV6 address of the Wi-Fi connection
   *
   * @syscap SystemCapability.Communication.WiFi.STA
   * @since 10
   */
  secondDNS: string;
}