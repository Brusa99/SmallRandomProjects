-- indexes on tables

CREATE INDEX l_partkey_index ON lineitem(l_partkey); --used
CREATE INDEX l_suppkey_index ON lineitem(l_suppkey);
CREATE INDEX l_orderkey_index ON lineitem(l_orderkey);

CREATE INDEX o_orderkey_index ON orders(o_orderkey);
CREATE INDEX o_custkey_index ON orders(o_custkey);

CREATE INDEX c_custkey_index ON customer(c_custkey);
CREATE INDEX c_nationkey_index ON customer(c_nationkey);

CREATE INDEX p_partkey_index ON part(p_partkey);
CREATE INDEX p_type_index ON part(p_type); --used

CREATE INDEX s_suppkey_index ON supplier(s_suppkey);
CREATE INDEX s_nationkey_index ON supplier(s_nationkey); --used

CREATE INDEX n_nationkey_index ON nation(n_nationkey);
CREATE INDEX n_regionkey_index ON nation(n_regionkey);
CREATE INDEX n_name_index ON nation(n_name);

CREATE INDEX r_regionkey_index ON region(r_regionkey);

-- indexes on materialized views

CREATE INDEX e_orderkey_ind ON exp(e_orderkey);
CREATE INDEX e_partkey_ind ON exp(e_partkey);
CREATE INDEX e_suppkey_ind ON exp(e_suppkey);
CREATE INDEX e_type_ind ON exp(e_type); --used
CREATE INDEX e_nname_ind ON exp(e_nname); --used

CREATE INDEX i_orderkey_ind ON imp(i_orderkey); --used
CREATE INDEX i_partkey_ind ON imp(i_partkey); --used
CREATE INDEX i_suppkey_ind ON imp(i_suppkey);
CREATE INDEX i_nnami_ind ON imp(i_nname);