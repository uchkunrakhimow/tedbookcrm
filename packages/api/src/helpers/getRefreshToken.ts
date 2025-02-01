export default function getRefreshToken(cookieString: string) {
  const regex = /refreshToken=([^;]+)/;
  const match = cookieString.match(regex);
  return match ? match[1] : null;
}
