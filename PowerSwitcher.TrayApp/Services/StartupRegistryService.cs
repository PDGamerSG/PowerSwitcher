using Microsoft.Win32;
using System.Reflection;

namespace PowerSwitcher.TrayApp.Services
{
    /// <summary>
    /// Controls whether the application launches automatically on Windows logon.
    /// Uses the per-user "Run" registry key so it works for the unpackaged build
    /// and never requires administrator rights.
    /// </summary>
    public static class StartupRegistryService
    {
        const string RunKeyPath = @"Software\Microsoft\Windows\CurrentVersion\Run";
        const string AppRegistryValueName = "PowerPlanSwitcher";

        // The service is compiled into the .exe, so the executing assembly's
        // location is the full path of the application executable to launch.
        static string ExecutablePath => Assembly.GetExecutingAssembly().Location;

        public static bool IsEnabled()
        {
            using (var runKey = Registry.CurrentUser.OpenSubKey(RunKeyPath, writable: false))
            {
                return runKey?.GetValue(AppRegistryValueName) != null;
            }
        }

        public static void SetEnabled(bool enabled)
        {
            using (var runKey = Registry.CurrentUser.OpenSubKey(RunKeyPath, writable: true)
                                ?? Registry.CurrentUser.CreateSubKey(RunKeyPath))
            {
                if (runKey == null) { return; }

                if (enabled)
                {
                    // Quote the path so spaces (e.g. "Program Files") are handled.
                    runKey.SetValue(AppRegistryValueName, $"\"{ExecutablePath}\"");
                }
                else if (runKey.GetValue(AppRegistryValueName) != null)
                {
                    runKey.DeleteValue(AppRegistryValueName, throwOnMissingValue: false);
                }
            }
        }
    }
}
