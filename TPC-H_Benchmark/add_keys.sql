ALTER TABLE PART
    ADD PRIMARY KEY (P_PARTKEY);

ALTER TABLE SUPPLIER
    ADD PRIMARY KEY (S_SUPPKEY);

ALTER TABLE PARTSUPP
    ADD PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY);

ALTER TABLE CUSTOMER
    ADD PRIMARY KEY (C_CUSTKEY);

ALTER TABLE ORDERS
    ADD PRIMARY KEY (O_ORDERKEY);

ALTER TABLE LINEITEM
    ADD PRIMARY KEY (L_ORDERKEY, L_LINENUMBER);

ALTER TABLE NATION
    ADD PRIMARY KEY (N_NATIONKEY);

ALTER TABLE REGION
    ADD PRIMARY KEY (R_REGIONKEY);

ALTER TABLE supplier
    ADD FOREIGN KEY (s_nationkey) REFERENCES nation(N_NATIONKEY);

ALTER TABLE partsupp
    ADD FOREIGN KEY (ps_partkey) REFERENCES part(p_partkey);

ALTER TABLE partsupp
    ADD FOREIGN KEY (ps_suppkey) REFERENCES supplier(s_suppkey);

ALTER TABLE customer
    ADD FOREIGN KEY (c_nationkey) REFERENCES nation(n_nationkey);

ALTER TABLE orders
    ADD FOREIGN KEY (o_custkey) REFERENCES  customer(c_custkey);

ALTER TABLE lineitem
    ADD FOREIGN KEY (l_orderkey) REFERENCES orders(o_orderkey);

ALTER TABLE lineitem
    ADD FOREIGN KEY (l_partkey) REFERENCES part(p_partkey);

ALTER TABLE lineitem
    ADD FOREIGN KEY (l_suppkey) REFERENCES supplier(s_suppkey);

ALTER TABLE lineitem
    ADD FOREIGN KEY (l_partkey, l_suppkey) REFERENCES partsupp(ps_partkey, ps_suppkey);

ALTER TABLE nation
    ADD FOREIGN KEY (n_regionkey) REFERENCES region(r_regionkey);