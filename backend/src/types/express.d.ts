declare global {
  namespace Express {
    interface Request {
      auth?: {
        userId: string;
        accessToken: string;
      };
      validated?: unknown;
    }
  }
}

export {};
