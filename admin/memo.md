pnpm prettier --write "**/*.tsx"


npm run build


pnpm install uuid



```
curl -X POST https://admin.reaction-development.swiswiswift.com/api/generate-upload-url \
  -H "Content-Type: application/json" \
  -d '{"imageName": "25fa8a8c-d49b-4884-b3ee-f8c203c0a7aa.png"}' | jq
```

```
{
  "uploadUrl": "https://s3.ap-northeast-1.amazonaws.com/admin-storage.reaction-development.swiswiswift.com/25fa8a8c-d49b-4884-b3ee-f8c203c0a7aa.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAWZ5SLZIHETVKBL23%2F20250506%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20250506T121041Z&X-Amz-Expires=900&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJz%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLW5vcnRoZWFzdC0xIkgwRgIhAOFz%2FBBlly5Nac5AJqqOIlJQfZM2wp%2BvQv%2BZHOkkhynPAiEAwUnyJni4XZpx51lS6safseuB%2BZM28Sr5Spj8%2FR0DuJ4q8QIIRRAAGgw0Njc5ODg2MzAwMzAiDFecd4aJBQ7d43PrOirOAte0LwtbV3fQ%2B%2BJR7MPqhcPT9CgTFkMxn3ybwskutxkMRRx7G35kRJzcUDnStmgZo4ecC0EbrT%2BPKqWZMxHvUUvVQ%2FmqB7A563Vnbg69r5qkxDLKVUlt%2FI9DHyMBiA3bnADrqH1wALrqJEtxLjamlIAhnIKofaTXQbSuB5l5tfKzUIAtN7a6a%2B7IreW5a4bYI8pSQXqM0BKflneOK%2BwA1WZ0S9GcB%2F4VN2fuw7t3hrn2ywGpB7nA4Sdfkt4QZoS5ixFovPAASKmMa%2B5pmD9eIy2UMQD0Op9OS4C1dbeXRYNUsJcYNB94i4R3YJCFglMZ4m9rrhuiKRkaKM6AeFtS3w7M4NBoYc139Gc91bEecXrrmED%2FcfXIRclMuvmr4%2BCGFdNGUd7b66XIcB050WOBflG%2FyK0dA5i%2BenTM9nYSLYcGWCvFGSTJGtzvDCGPmPAw3PbnwAY6nQF0NYXveXiKSq%2B4Gr1AuWGwMANsF8me1G1HMOGJufDRKA9vM%2FrwVV49bXPfY4%2BHeG8nIJtLnxxEzmJoDKQXIVQRt9ZZ7L5u%2FPaIqwjUDsbAOoyVyJhBdWmnXtK7Ftpogt2XgKctUzY%2FiO39epKYENQWPQZ%2FuWfNuDmRgWm%2BMCxHFl5wfCnLSbNYI5t60Ag84dvoYIWRxpsZybEP4Q5t&X-Amz-SignedHeaders=host&x-id=PutObject&X-Amz-Signature=318b66be1e3eb4555023febbe2854596397bb5fda1f1261f39af716c5fd2ef90"
}
```


curl -X PUT -T icon.png \
  -H "Content-Type: image/png" \
  "https://s3.ap-northeast-1.amazonaws.com/admin-storage.reaction-development.swiswiswift.com/25fa8a8c-d49b-4884-b3ee-f8c203c0a7aa.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIAWZ5SLZIHETVKBL23%2F20250506%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Date=20250506T121041Z&X-Amz-Expires=900&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJz%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLW5vcnRoZWFzdC0xIkgwRgIhAOFz%2FBBlly5Nac5AJqqOIlJQfZM2wp%2BvQv%2BZHOkkhynPAiEAwUnyJni4XZpx51lS6safseuB%2BZM28Sr5Spj8%2FR0DuJ4q8QIIRRAAGgw0Njc5ODg2MzAwMzAiDFecd4aJBQ7d43PrOirOAte0LwtbV3fQ%2B%2BJR7MPqhcPT9CgTFkMxn3ybwskutxkMRRx7G35kRJzcUDnStmgZo4ecC0EbrT%2BPKqWZMxHvUUvVQ%2FmqB7A563Vnbg69r5qkxDLKVUlt%2FI9DHyMBiA3bnADrqH1wALrqJEtxLjamlIAhnIKofaTXQbSuB5l5tfKzUIAtN7a6a%2B7IreW5a4bYI8pSQXqM0BKflneOK%2BwA1WZ0S9GcB%2F4VN2fuw7t3hrn2ywGpB7nA4Sdfkt4QZoS5ixFovPAASKmMa%2B5pmD9eIy2UMQD0Op9OS4C1dbeXRYNUsJcYNB94i4R3YJCFglMZ4m9rrhuiKRkaKM6AeFtS3w7M4NBoYc139Gc91bEecXrrmED%2FcfXIRclMuvmr4%2BCGFdNGUd7b66XIcB050WOBflG%2FyK0dA5i%2BenTM9nYSLYcGWCvFGSTJGtzvDCGPmPAw3PbnwAY6nQF0NYXveXiKSq%2B4Gr1AuWGwMANsF8me1G1HMOGJufDRKA9vM%2FrwVV49bXPfY4%2BHeG8nIJtLnxxEzmJoDKQXIVQRt9ZZ7L5u%2FPaIqwjUDsbAOoyVyJhBdWmnXtK7Ftpogt2XgKctUzY%2FiO39epKYENQWPQZ%2FuWfNuDmRgWm%2BMCxHFl5wfCnLSbNYI5t60Ag84dvoYIWRxpsZybEP4Q5t&X-Amz-SignedHeaders=host&x-id=PutObject&X-Amz-Signature=318b66be1e3eb4555023febbe2854596397bb5fda1f1261f39af716c5fd2ef90"


