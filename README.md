# TransitFlow-Aministrator

Ovaj repozitoriji sadrži **administratorski dio aplikacije TransitFlow** (backend API, admin Flutter aplikaciju i worker za notifikacije) koji je prvobitno rađen kao zaseban projekat.

Za **kompletnu aplikaciju (backend + admin + mobilna aplikacija za korisnike)** koristi se glavni repozitorij:

- Naziv: `TransitFlow`

U glavnom repozitoriju se nalazi:
- Backend (`backend/`)
- Admin Flutter aplikacija (`admin-frontend/`)
- Mobilna Flutter aplikacija za korisnike (`user-mobile/`)
- Worker servis (`worker/`)
- Detaljan README sa uputama za pokretanje cijelog sistema

## Šta sadrži ovaj repozitorij

- `backend/` – ASP.NET Core Web API (usklađen sa backendom iz glavnog `TransitFlow` repozitorija)
- `frontend/` – Flutter desktop aplikacija za administratore (prethodni naziv za admin dio)
- `worker/` – .NET Worker servis za notifikacije
- `.gitignore`, `docker-compose.yml` – osnovna konfiguracija za ovaj projekat

Kod u ovom repozitoriju je **usklađen** sa backendom, admin aplikacijom i workerom iz glavnog repozitorija `TransitFlow`, ali ovdje **nije** uključena mobilna korisnička aplikacija.

## Preporuka

Za razvoj, testiranje i evaluaciju kompletnog seminarskog rada (desktop + mobile + backend + worker), koristiti glavni repozitorij:

`TransitFlow`

