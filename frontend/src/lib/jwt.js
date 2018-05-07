TEST_TOKEN = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhZG1pbiI6dHJ1ZSwiYXVkIjoiYmFyY2hlZiIsImV4cCI6MTUyODA3ODY5OCwiaWF0IjoxNTI1NjU5NDk4LCJpc3MiOiJiYXJjaGVmIiwianRpIjoiOWEyMjM1MzQtZGU2My00M2Y4LTllZjAtOTM2ODY3OGViMjFjIiwibmJmIjoxNTI1NjU5NDk3LCJzdWIiOiJqYXNvbkBkZWFkdHJlZXBhZ2VzLmNvbSIsInR5cCI6ImFjY2VzcyJ9.S0SO1NLCcP0T0Y8ILSzr9x4zc3dHuIlF6sLPWRJHccWa7jqYUvnsYf8zmgKpuDoci-ZLAX-aQ8pMEmdYX_HCEQ"


export class JWS {

  constructor(token) {
    let jws = decodeJWS(token);
    this.header = jws.header;
    this.payload = jws.payload;
    this.token = token;
  }

  isExpired() {
    let exp = this.payload.exp;
    let expDate = new Date(exp);
    let now = new Date();
    return expDate <= now;
  }

  shouldRefresh() {
    // DO refresh happen after expiry?
  }
}


function decodeJWS(serializedJWS) {
  let parts = serializedJWS.split('.');
  let b64header = parts[0];
  let b64payload = parts[1];

  let header = JSON.parse(window.atob(b64header));
  let payload = JSON.parse(window.atob(b64payload));
  return { header, payload};
}
