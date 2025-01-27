# Working Zone
Project for the Reti Logiche course at Politecnico di Milano. 

## The problem
La specifica della Prova finale (Progetto di Reti Logiche) 2019 è ispirata al metodo di codifica a bassa dissipazione di potenza denominato “Working Zone”.
Il metodo di codifica Working Zone è un metodo pensato per il Bus Indirizzi che si usa per trasformare il valore di un indirizzo quando questo viene trasmesso, se appartiene a certi intervalli (detti appunto working-zone). Una working-zone è definita come un intervallo di indirizzi di dimensione fissa (Dwz) che parte da un indirizzo base. All’interno dello schema di codifica possono esistere multiple working-zone (Nwz).
Lo schema modificato di codifica da implementare è il seguente:
- se l’indirizzo da trasmettere (ADDR) non appartiene a nessuna Working Zone, esso viene trasmesso così come è, e un bit addizionale rispetto ai bit di indirizzamento (WZ_BIT) viene messo a 0. In pratica dato ADDR, verrà trasmesso WZ_BIT=0 concatenato ad ADDR (WZ_BIT & ADDR, dove & è il simbolo di concatenazione);
- se l’indirizzo da trasmettere (ADDR) appartiene ad una Working Zone, il bit addizionale WZ_BIT è posto a 1, mentre i bit di indirizzo vengono divisi in 2 sotto campi rappresentanti:
- Il numero della working-zone al quale l’indirizzo appartiene WZ_NUM, che sarà codificato in binario
- L’offset rispetto all’indirizzo di base della working zone WZ_OFFSET, codificato come one-hot (cioè il valore da rappresentare è equivalente all’unico bit a 1 della codifica).

In pratica dato ADDR, verrà trasmesso WZ_BIT=1 concatenato ad WZ_NUM e WZ_OFFSET ( WZ_BIT & WZ_NUM & WZ_OFFSET, dove & è il simbolo di concatenazione)
Nella versione da implementare il numero di bit da considerare per l’indirizzo da codificare è 7. Il che definisce come indirizzi validi quelli da 0 a 127. Il numero di working-zone è 8 (Nwz=8) mentre la dimensione della working-zone è 4 indirizzi incluso quello base (Dwz=4). Questo comporta che l’indirizzo codificato sarà composto da 8 bit: 1 bit per WZ_BIT + 7 bit per ADDR, oppure 1 bit per WZ_BIT, 3 bit per codificare in binario a quale tra le 8 working zone l’indirizzo appartiene, e 4 bit per codificare one hot il valore dell’offset di ADDR rispetto all’indirizzo base.
Il modulo da implementare leggerà l’indirizzo da codificare e gli 8 indirizzi base delle working- zone e dovrà produrre l’indirizzo opportunamente codificato.

## Authors
- Lorenzo Lacchini
- Luca Minotti ([@lucagrammer](https://github.com/lucagrammer))
