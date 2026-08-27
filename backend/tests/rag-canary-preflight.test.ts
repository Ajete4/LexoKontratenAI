import { describe, expect, it } from "vitest";

import { evaluateAnonCanaryPreflight } from "../src/rag/rag-canary-preflight.js";

const verifiedPrivileges = {
  anonExecute: false,
  authenticatedExecute: false,
  serviceRoleExecute: true,
  rlsEnabled: true
} as const;

describe("RAG canary anon preflight classification", () => {
  it.each([401, 403] as const)("treats HTTP %s denial as PASS", (status) => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges,
      openApiObservation: { kind: "http_denied", status }
    })).toEqual({
      status: "PASS",
      safeCode: "ANON_RPC_DENIED",
      canaryBlocked: false,
      privilegeEvidenceAccepted: true
    });
  });

  it("treats an RPC absent from the anon schema as PASS", () => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges,
      openApiObservation: { kind: "rpc_absent" }
    })).toMatchObject({ status: "PASS", canaryBlocked: false });
  });

  it("classifies a network error as NOT_EVALUATED without disputing verified privileges", () => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges,
      openApiObservation: { kind: "network_error" }
    })).toEqual({
      status: "NOT_EVALUATED",
      safeCode: "ANON_OPENAPI_NOT_EVALUATED",
      canaryBlocked: false,
      privilegeEvidenceAccepted: true
    });
  });

  it("does not require the remote OpenAPI probe after manual privilege verification", () => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges,
      openApiObservation: { kind: "not_attempted" }
    })).toMatchObject({
      status: "NOT_EVALUATED",
      canaryBlocked: false,
      privilegeEvidenceAccepted: true
    });
  });

  it("blocks a contradictory observation where the RPC is visible to anon", () => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges,
      openApiObservation: { kind: "rpc_visible" }
    })).toMatchObject({
      status: "BLOCKED",
      safeCode: "ANON_RPC_UNEXPECTEDLY_VISIBLE",
      canaryBlocked: true
    });
  });

  it("blocks missing or incompatible manual privilege evidence", () => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges: { ...verifiedPrivileges, anonExecute: true },
      openApiObservation: { kind: "http_denied", status: 403 }
    })).toMatchObject({
      status: "BLOCKED",
      safeCode: "RAG_PRIVILEGE_EVIDENCE_INVALID",
      privilegeEvidenceAccepted: false
    });
  });

  it("keeps raw network errors, credentials and responses outside the contract", () => {
    expect(evaluateAnonCanaryPreflight({
      verifiedPrivileges,
      openApiObservation: {
        kind: "network_error",
        rawError: "must not be accepted",
        token: "must not be accepted"
      }
    })).toMatchObject({
      status: "NOT_EVALUATED",
      safeCode: "ANON_OPENAPI_OBSERVATION_INVALID",
      canaryBlocked: false
    });
  });
});
