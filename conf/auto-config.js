(function () {
    // Run after DOM starts but before main app scripts
    document.addEventListener('DOMContentLoaded', async () => {
        const CONFIG_URL = './config.json';
        console.log('[auto-config] Loading config from', CONFIG_URL);

        try {
            const res = await fetch(CONFIG_URL, { cache: 'no-store' });
            if (!res.ok) {
                console.error('[auto-config] Failed to fetch config.json:', res.status, res.statusText);
                return;
            }

            const cfg = await res.json();
            if (typeof cfg !== 'object' || cfg === null) {
                console.error('[auto-config] Invalid config.json structure:', cfg);
                return;
            }

            let stored = 0;
            for (const [key, value] of Object.entries(cfg)) {
                try {
                    const strValue = typeof value === 'object' ? JSON.stringify(value) : String(value);
                    localStorage.setItem(key, strValue);
                    stored++;
                    console.log(`[auto-config] Stored ${key} =`, strValue);
                } catch (e) {
                    console.warn(`[auto-config] Failed to store ${key}:`, e);
                }
            }

            console.log(`[auto-config] Done. Stored ${stored} config values to localStorage.`);
        } catch (e) {
            console.error('[auto-config] Error loading config.json:', e);
        }
    });
})();
