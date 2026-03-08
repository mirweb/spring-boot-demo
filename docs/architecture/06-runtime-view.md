# Runtime View

## Greeting request

1. A user opens the application in the browser.
2. Spring Boot serves the Angular application assets.
3. The Angular app issues a request to `GET /api/hello`, optionally with `name`.
4. The backend logs the request parameter and returns a JSON response.
5. The Angular UI renders the greeting text.

## SPA navigation

1. A browser requests `/` or `/app/**`.
2. Spring MVC forwards the request to `/index.html`.
3. The Angular router takes over client-side navigation.
