function handler(event) {
    var request = event.request;
    var headers = request.headers;

    var username = '${admin_user}';
    var password = '${admin_password}';
    var expectedAuth = 'Basic ' + btoa(username + ':' + password);

    if (!headers.authorization || headers.authorization.value !== expectedAuth) {
        return {
            statusCode: 401,
            statusDescription: 'Unauthorized',
            headers: {
                'www-authenticate': {
                    value: 'Basic realm="Restricted Area"',
                },
            },
        };
    }

    return request;
}
