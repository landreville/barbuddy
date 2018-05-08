function decodeJWS(serializedJWS) {
  let parts = serializedJWS.split('.');
  let b64header = parts[0];
  let b64payload = parts[1];

  let header = JSON.parse(window.atob(b64header));
  let payload = JSON.parse(window.atob(b64payload));
  return { header, payload };
}


export class JWS {

  constructor(accessToken) {
    let jws = decodeJWS(accessToken);
    this.header = jws.header;
    this.payload = jws.payload;
    this.expDate = new Date(this.payload.exp * 1000);
    this.accessToken = accessToken;
  }

  isExpired() {
    let now = new Date();
    return this.expDate <= now;
  }

  shouldRefresh() {
    let soon = new Date();
    soon.setDate(soon + 4);
    return this.expDate < soon;
  }
}
