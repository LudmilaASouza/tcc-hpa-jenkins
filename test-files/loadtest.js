import http from 'k6/http';
import { check, sleep } from 'k6';
export let options = {
  stages: [
    { duration: '2m', target: 20  },
    { duration: '3m', target: 50 },
    { duration: '2m', target: 0  },
  ],
};
export default function() {
  let res = http.get('http://localhost:8888');
  check(res, { 'status 200': (r) => r.status === 200 });
  sleep(1);
}