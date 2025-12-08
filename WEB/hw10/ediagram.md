```mermaid
erDiagram
    LOCATION ||--|| LOCATION_INFO : "1:1"
    LOCATION ||--o{ CHARACTER : "1:N (home_location_id)"
    CHARACTER }o--o{ CHARACTER_VISIT : "M:N (посещения)"
    LOCATION  }o--o{ CHARACTER_VISIT : ""
```