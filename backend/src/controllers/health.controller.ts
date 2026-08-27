import type { RequestHandler } from "express";

import { env } from "../config/env.js";
import { supabaseAdmin } from "../config/supabase.js";

export type DatabaseHealthCheck = () => Promise<boolean>;

export const checkDatabaseHealth: DatabaseHealthCheck = async () => {
  const { error } = await supabaseAdmin
    .from("legal_sources")
    .select("id", { count: "exact", head: true });

  return !error;
};

export const getHealth: RequestHandler = (_request, response) => {
  response.status(200).json({
    status: "ok",
    service: "lexokontraten-api",
    environment: env.NODE_ENV
  });
};

export function createGetDatabaseHealth(
  checkDatabase: DatabaseHealthCheck = checkDatabaseHealth
): RequestHandler {
  return async (_request, response) => {
    try {
      const isConnected = await checkDatabase();

      if (!isConnected) {
        response.status(503).json({
          status: "error",
          database: "unavailable"
        });
        return;
      }

      response.status(200).json({
        status: "ok",
        database: "connected"
      });
    } catch {
      response.status(503).json({
        status: "error",
        database: "unavailable"
      });
    }
  };
}
