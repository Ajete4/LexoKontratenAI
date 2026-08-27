import { z } from "zod";

const verifiedPrivilegeSchema = z.object({
  anonExecute: z.literal(false),
  authenticatedExecute: z.literal(false),
  serviceRoleExecute: z.literal(true),
  rlsEnabled: z.literal(true)
}).strict();

const anonOpenApiObservationSchema = z.discriminatedUnion("kind", [
  z.object({ kind: z.literal("http_denied"), status: z.union([z.literal(401), z.literal(403)]) }).strict(),
  z.object({ kind: z.literal("rpc_absent") }).strict(),
  z.object({ kind: z.literal("rpc_visible") }).strict(),
  z.object({ kind: z.literal("network_error") }).strict(),
  z.object({ kind: z.literal("not_attempted") }).strict()
]);

export type VerifiedRagPrivileges = z.infer<typeof verifiedPrivilegeSchema>;
export type AnonOpenApiObservation = z.infer<typeof anonOpenApiObservationSchema>;

export type AnonPreflightResult = {
  status: "PASS" | "NOT_EVALUATED" | "BLOCKED";
  safeCode: string;
  canaryBlocked: boolean;
  privilegeEvidenceAccepted: boolean;
};

export function evaluateAnonCanaryPreflight(input: {
  verifiedPrivileges: unknown;
  openApiObservation: unknown;
}): AnonPreflightResult {
  const privileges = verifiedPrivilegeSchema.safeParse(input.verifiedPrivileges);
  if (!privileges.success) {
    return {
      status: "BLOCKED",
      safeCode: "RAG_PRIVILEGE_EVIDENCE_INVALID",
      canaryBlocked: true,
      privilegeEvidenceAccepted: false
    };
  }

  const observation = anonOpenApiObservationSchema.safeParse(input.openApiObservation);
  if (!observation.success) {
    return {
      status: "NOT_EVALUATED",
      safeCode: "ANON_OPENAPI_OBSERVATION_INVALID",
      canaryBlocked: false,
      privilegeEvidenceAccepted: true
    };
  }

  if (
    observation.data.kind === "http_denied" ||
    observation.data.kind === "rpc_absent"
  ) {
    return {
      status: "PASS",
      safeCode: "ANON_RPC_DENIED",
      canaryBlocked: false,
      privilegeEvidenceAccepted: true
    };
  }

  if (
    observation.data.kind === "network_error" ||
    observation.data.kind === "not_attempted"
  ) {
    return {
      status: "NOT_EVALUATED",
      safeCode: "ANON_OPENAPI_NOT_EVALUATED",
      canaryBlocked: false,
      privilegeEvidenceAccepted: true
    };
  }

  return {
    status: "BLOCKED",
    safeCode: "ANON_RPC_UNEXPECTEDLY_VISIBLE",
    canaryBlocked: true,
    privilegeEvidenceAccepted: true
  };
}
