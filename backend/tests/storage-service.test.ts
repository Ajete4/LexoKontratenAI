import type { SupabaseClient } from "@supabase/supabase-js";
import { describe, expect, it, vi } from "vitest";

import { createContractFileStorage } from "../src/services/storage.service.js";

type DownloadResult = {
  data: Blob | null;
  error: { message: string; statusCode?: string } | null;
};

function createStorage(downloadResult: DownloadResult) {
  const download = vi.fn(async () => downloadResult);
  const from = vi.fn(() => ({ download }));
  const adminClient = {
    storage: { from }
  } as unknown as SupabaseClient;

  return {
    download,
    from,
    storage: createContractFileStorage(adminClient)
  };
}

describe("contract file Storage download", () => {
  it("downloads a private object into memory from the fixed bucket", async () => {
    const buffer = Buffer.from("Kontratë testuese me tekst të mjaftueshëm.");
    const context = createStorage({
      data: new Blob([buffer]),
      error: null
    });

    await expect(context.storage.download("verified-database-path")).resolves.toEqual(
      buffer
    );
    expect(context.from).toHaveBeenCalledWith("contract-files");
    expect(context.download).toHaveBeenCalledWith("verified-database-path");
  });

  it("maps a missing object to a safe 404", async () => {
    const context = createStorage({
      data: null,
      error: { message: "private object detail", statusCode: "404" }
    });

    await expect(context.storage.download("verified-database-path")).rejects.toMatchObject({
      code: "STORAGE_OBJECT_NOT_FOUND",
      message: "The stored contract file was not found.",
      statusCode: 404
    });
  });

  it("maps a Storage failure without exposing raw details", async () => {
    const context = createStorage({
      data: null,
      error: { message: "private provider failure", statusCode: "500" }
    });

    await expect(context.storage.download("verified-database-path")).rejects.toMatchObject({
      code: "STORAGE_UNAVAILABLE",
      message: "The stored contract file could not be downloaded at this time.",
      statusCode: 503
    });
  });

  it.each([null, new Blob([])])(
    "rejects a missing or empty download as incomplete",
    async (data) => {
      const context = createStorage({ data, error: null });

      await expect(
        context.storage.download("verified-database-path")
      ).rejects.toMatchObject({
        code: "STORAGE_DOWNLOAD_INCOMPLETE",
        statusCode: 503
      });
    }
  );
});
