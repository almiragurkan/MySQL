explain select * from proteins where accession = "Q9NQS3";
explain select * from proteins where pid like "%HUMAN";

create index idx1 on proteins(accession);
create index idx2 on proteins(pid);

alter table proteins drop idx1;