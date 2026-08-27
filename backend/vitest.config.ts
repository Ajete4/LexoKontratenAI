import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node",
    env: {
      NODE_ENV: "test",
      FRONTEND_URL: "http://localhost:5173",
      SUPABASE_URL: "https://example.supabase.co",
      SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
      SUPABASE_SECRET_KEY: "sb_secret_test-only-placeholder"
    }
  }
});
