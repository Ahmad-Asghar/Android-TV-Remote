import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import org.cybergarage.upnp.ControlPoint
import org.cybergarage.upnp.Device
import java.net.InetAddress
import java.net.NetworkInterface
import java.util.Collections

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.example.network/devices"
        private const val TAG = "NetworkScanner"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDevices") {
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val devices = getDevicesOnNetwork()
                            withContext(Dispatchers.Main) {
                                result.success(devices)
                            }
                        } catch (e: Exception) {
                            Log.e(TAG, "Error: ${e.message}", e)
                            withContext(Dispatchers.Main) {
                                result.error("ERROR", e.message, null)
                            }
                        }
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private suspend fun getDevicesOnNetwork(): List<Map<String, String>> = withContext(Dispatchers.IO) {
        val devices = Collections.synchronizedList(mutableListOf<Map<String, String>>())
        val subnet = getSubnet()

        if (subnet == null) {
            Log.e(TAG, "Subnet is null. Cannot scan devices.")
            return@withContext devices
        }

        val jobs = (1..254).map { i ->
            val host = "$subnet$i"
            async {
                try {
                    val address = InetAddress.getByName(host)
                    if (address.isReachable(3000)) { // Ping with 3-second timeout
                        val isAndroidTV = checkIfAndroidTv(address)
                        Log.d(TAG, "Device found: $host, Android TV: $isAndroidTV")
                        devices.add(
                            mapOf(
                                "ip" to host,
                                "deviceName" to getDeviceName(address) ?: "Unknown",
                                "isAndroidTV" to isAndroidTV.toString()
                            )
                        )
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error scanning host: $host", e)
                }
            }
        }

        jobs.awaitAll() // Wait for all tasks to finish
        devices
    }

    private fun getSubnet(): String? {
        try {
            val ip = getLocalIpAddress() ?: return null
            return ip.substring(0, ip.lastIndexOf('.') + 1)
        } catch (e: Exception) {
            Log.e(TAG, "Error getting subnet", e)
            return null
        }
    }

    private fun getLocalIpAddress(): String? {
        try {
            val interfaces = NetworkInterface.getNetworkInterfaces()
            for (networkInterface in Collections.list(interfaces)) {
                for (address in Collections.list(networkInterface.inetAddresses)) {
                    if (!address.isLoopbackAddress && address is InetAddress) {
                        val hostAddress = address.hostAddress
                        if (hostAddress.indexOf(':') < 0) { // Ignore IPv6
                            return hostAddress
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error getting local IP address", e)
        }
        return null
    }

    private fun checkIfAndroidTv(address: InetAddress): Boolean {
        try {
            // Use mDNS or UPnP to query device details
            val controlPoint = ControlPoint()
            controlPoint.search()

            for (device in controlPoint.deviceList) {
                if (device != null && device.ipAddress == address.hostAddress) {
                    val deviceType = device.deviceType
                    return deviceType.contains("media") && deviceType.contains("tv", ignoreCase = true)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error checking Android TV for host: ${address.hostAddress}", e)
        }
        return false
    }

    private fun getDeviceName(address: InetAddress): String? {
        try {
            return address.hostName
        } catch (e: Exception) {
            Log.e(TAG, "Error fetching device name for host: ${address.hostAddress}", e)
        }
        return null
    }
}
