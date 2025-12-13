<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header -->
      <div class="mb-6">
        <div class="flex items-center justify-between mb-4">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">Patch Status Monitor</h1>
            <p class="text-gray-600 mt-1">Enterprise System Compliance Dashboard</p>
          </div>
          <button
            @click="togglePolling"
            :class="[
              'flex items-center gap-2 px-4 py-2 rounded-lg font-medium',
              isPolling 
                ? 'bg-green-600 text-white hover:bg-green-700' 
                : 'bg-gray-600 text-white hover:bg-gray-700'
            ]"
          >
            <span :class="{'animate-spin': isPolling}">⟳</span>
            {{ isPolling ? 'Polling Active' : 'Polling Paused' }}
          </button>
        </div>
        <div class="text-sm text-gray-500">
          Last updated: {{ lastUpdate }}
        </div>
      </div>

      <!-- Summary Cards -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-blue-500">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-600">Overall Compliance</p>
              <p class="text-3xl font-bold text-gray-900">{{ overallCompliance }}%</p>
            </div>
            <span class="text-4xl">📈</span>
          </div>
        </div>

        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-green-500">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-600">Patched Systems</p>
              <p class="text-3xl font-bold text-gray-900">{{ totalPatched }}/{{ totalSystems }}</p>
            </div>
            <span class="text-4xl">✓</span>
          </div>
        </div>

        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-red-500">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-600">Critical Patches</p>
              <p class="text-3xl font-bold text-gray-900">{{ totalCritical }}</p>
            </div>
            <span class="text-4xl">⚠</span>
          </div>
        </div>

        <div class="bg-white rounded-lg shadow p-6 border-l-4 border-yellow-500">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-600">Active Alerts</p>
              <p class="text-3xl font-bold text-gray-900">{{ alerts.length }}</p>
            </div>
            <span class="text-4xl">🔔</span>
          </div>
        </div>
      </div>

      <!-- Alerts Section -->
      <div v-if="alerts.length > 0" class="bg-white rounded-lg shadow mb-6">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
            <span>🔔</span>
            Recent Alerts
          </h2>
        </div>
        <div class="p-6">
          <div class="space-y-3">
            <div
              v-for="alert in alerts"
              :key="alert.id"
              :class="[
                'p-4 rounded-lg border-l-4',
                alert.severity === 'high' 
                  ? 'bg-red-50 border-red-500' 
                  : 'bg-yellow-50 border-yellow-500'
              ]"
            >
              <div class="flex items-start justify-between">
                <div class="flex items-start gap-3">
                  <span :class="[
                    'text-xl',
                    alert.severity === 'high' ? 'text-red-600' : 'text-yellow-600'
                  ]">⚠</span>
                  <div>
                    <p class="font-semibold text-gray-900">{{ alert.systemName }}</p>
                    <p class="text-sm text-gray-700 mt-1">{{ alert.message }}</p>
                  </div>
                </div>
                <span class="text-xs text-gray-500">
                  {{ formatTime(alert.timestamp) }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- System Status Grid -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
            <span>🖥️</span>
            System Patch Status
          </h2>
        </div>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div
              v-for="system in systems"
              :key="system.id"
              :class="['border-2 rounded-lg p-5', getStatusBg(system)]"
            >
              <div class="flex items-start justify-between mb-3">
                <div>
                  <h3 class="font-semibold text-gray-900">{{ system.name }}</h3>
                  <p class="text-xs text-gray-600 mt-1">{{ system.endpoint }}</p>
                </div>
                <span :class="['text-2xl', getStatusIconColor(system)]">
                  {{ getStatusIcon(system) }}
                </span>
              </div>

              <div class="mb-3">
                <div class="flex justify-between text-sm mb-1">
                  <span class="text-gray-700">Patch Compliance</span>
                  <span :class="['font-semibold', getStatusColor(system)]">
                    {{ getCompliance(system) }}%
                  </span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2.5">
                  <div
                    :class="['h-2.5 rounded-full transition-all duration-500', getProgressColor(system)]"
                    :style="{ width: getCompliance(system) + '%' }"
                  />
                </div>
              </div>

              <div class="grid grid-cols-3 gap-3 text-sm">
                <div>
                  <p class="text-gray-600">Total</p>
                  <p class="font-semibold text-gray-900">{{ system.total }}</p>
                </div>
                <div>
                  <p class="text-gray-600">Patched</p>
                  <p class="font-semibold text-green-700">{{ system.patched }}</p>
                </div>
                <div>
                  <p class="text-gray-600">Critical</p>
                  <p class="font-semibold text-red-700">{{ system.critical }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Historical Trend -->
      <div class="bg-white rounded-lg shadow mt-6">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-semibold text-gray-900">Compliance Trend</h2>
        </div>
        <div class="p-6">
          <div class="h-48 flex items-end justify-between gap-2">
            <div 
              v-for="(data, idx) in historicalData"
              :key="idx"
              class="flex-1 flex flex-col items-center gap-2"
            >
              <div
                class="w-full bg-blue-500 rounded-t transition-all duration-300 hover:bg-blue-600 cursor-pointer"
                :style="{ height: (data.compliance / 100 * 100) + '%' }"
                :title="data.compliance.toFixed(1) + '%'"
              />
              <span class="text-xs text-gray-500">
                {{ formatTrendTime(data.timestamp) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AutomatedPatchMonitor',
  data() {
    return {
      systems: [],
      alerts: [],
      isPolling: true,
      lastUpdate: new Date().toLocaleTimeString(), // FIXED: was toLocateTimeString
      historicalData: [],
      pollInterval: null
    };
  },
  computed: {
    totalSystems() {
      return this.systems.reduce((sum, s) => sum + s.total, 0); // FIXED: spacing
    },
    totalPatched() {
      return this.systems.reduce((sum, s) => sum + s.patched, 0);
    },
    totalCritical() {
      return this.systems.reduce((sum, s) => sum + s.critical, 0);
    },
    overallCompliance() {
      if (this.totalSystems === 0) return 0;
      return ((this.totalPatched / this.totalSystems) * 100).toFixed(1);
    }
  },
  methods: {
    initializeSystems() {
      this.systems = [
        { id: 1, name: 'Web Server Cluster', endpoint: '/api/webservers', total: 45, patched: 42, critical: 3 },
        { id: 2, name: 'Database Servers', endpoint: '/api/databases', total: 12, patched: 11, critical: 1 },
        { id: 3, name: 'Application Servers', endpoint: '/api/appservers', total: 28, patched: 28, critical: 0 },
        { id: 4, name: 'Load Balancers', endpoint: '/api/loadbalancers', total: 8, patched: 7, critical: 1 },
        { id: 5, name: 'File Servers', endpoint: '/api/fileservers', total: 15, patched: 13, critical: 2 },
        { id: 6, name: 'Email Servers', endpoint: '/api/mailservers', total: 6, patched: 6, critical: 0 }
      ];

      for (let i = 6; i >= 0; i--) {
        const date = new Date();
        date.setHours(date.getHours() - i);
        this.historicalData.push({
          timestamp: date,
          compliance: 85 + Math.random() * 10 // FIXED: was + instead of *
        });
      }
    },
    startPolling() {
      this.pollInterval = setInterval(() => { // FIXED: removed space in ( )
        this.updateSystems(); // FIXED: was updateSytems
        this.lastUpdate = new Date().toLocaleTimeString();
        this.updateHistoricalData();
      }, 3000);
    },
    stopPolling() {
      if (this.pollInterval) {
        clearInterval(this.pollInterval);
        this.pollInterval = null;
      }
    },
    togglePolling() { // FIXED: was tooglePolling
      this.isPolling = !this.isPolling;
      if (this.isPolling) {
        this.startPolling();
      } else {
        this.stopPolling();
      }
    },
    updateSystems() {
      this.systems = this.systems.map(system => {
        const change = Math.random();
        let newPatched = system.patched;
        let newCritical = system.critical;

        if (change < 0.1 && system.patched < system.total) {
          newPatched++;
          newCritical = Math.max(0, newCritical - 1);
        } else if (change > 0.95 && system.patched > system.total * 0.6) { // FIXED: was < 0.95
          newPatched--;
          newCritical++; // FIXED: added semicolon
        }

        const updatedSystem = { ...system, patched: newPatched, critical: newCritical }; // FIXED: was patched, newPatched

        const compliance = (updatedSystem.patched / updatedSystem.total) * 100;
        if (compliance < 85 && updatedSystem.critical > 0) {
          const existingAlert = this.alerts.find(a =>
            a.systemId === updatedSystem.id && a.timestamp > Date.now() - 60000 // FIXED: was DataTransfer.now()
          );
          if (!existingAlert) {
            this.addAlert(updatedSystem, compliance);
          }
        }

        return updatedSystem;
      });
    },
    addAlert(system, compliance) {
      const newAlert = {
        id: Date.now(),
        systemId: system.id,
        systemName: system.name,
        message: `Low compliance: ${compliance.toFixed(1)}% (${system.critical} critical patches missing)`, // FIXED: template literal
        severity: system.critical >= 3 ? 'high' : 'medium',
        timestamp: Date.now()
      };
      this.alerts = [newAlert, ...this.alerts].slice(0, 10); // FIXED: was new.Alert
    },
    updateHistoricalData() {
      const newData = {
        timestamp: new Date(),
        compliance: parseFloat(this.overallCompliance)
      };
      this.historicalData = [...this.historicalData, newData].slice(-20); // FIXED: was thishistoricalData
    },
    getCompliance(system) {
      return ((system.patched / system.total) * 100).toFixed(1);
    },
    getStatusColor(system) { // FIXED: removed duplicate method
      const percent = (system.patched / system.total) * 100;
      if (percent >= 95) return 'text-green-600';
      if (percent >= 85) return 'text-yellow-600';
      return 'text-red-600';
    },
    getStatusBg(system) {
      const percent = (system.patched / system.total) * 100;
      if (percent >= 95) return 'bg-green-100 border-green-300';
      if (percent >= 85) return 'bg-yellow-100 border-yellow-300';
      return 'bg-red-100 border-red-300';
    },
    getProgressColor(system) {
      const percent = (system.patched / system.total) * 100;
      if (percent >= 95) return 'bg-green-600';
      if (percent >= 85) return 'bg-yellow-500';
      return 'bg-red-600';
    },
    getStatusIcon(system) {
      const percent = (system.patched / system.total) * 100;
      if (percent >= 95) return '✓';
      if (system.critical > 0) return '✗'; // FIXED: was 'X'
      return '⏱';
    },
    getStatusIconColor(system) {
      const percent = (system.patched / system.total) * 100;
      if (percent >= 95) return 'text-green-600';
      if (system.critical > 0) return 'text-red-600';
      return 'text-yellow-600';
    },
    formatTime(timestamp) {
      return new Date(timestamp).toLocaleTimeString();
    },
    formatTrendTime(timestamp) {
      return new Date(timestamp).toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit'
      });
    }
  },
  mounted() {
    this.initializeSystems();
    this.startPolling();
  },
  beforeUnmount() {
    this.stopPolling();
  }
};
</script>

<style scoped>
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>