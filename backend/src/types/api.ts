export type ApiDataResponse<T> = {
  data: T;
};

export type AuthenticatedUser = {
  userId: string;
  accessToken: string;
};
