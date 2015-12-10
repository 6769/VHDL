use WORK.fourpack.all; -- fourpack is a resolved package for 4-variable logic
                       -- more details on resolution in next subsection

entity t_buff_exmpl is
  port(a, b, c, d: in X01Z;   -- signals are four-valued
       f: out X01Z);
end t_buff_exmpl;

architecture t_buff_conc of t_buff_exmpl is
begin
  f <= a when b = '1' else 'Z';
  f <= c when d = '1' else 'Z';
end t_buff_conc;

architecture t_buff_bhv of t_buff_exmpl is
begin
  buff1: process(a, b)
  begin
    if (b = '1') then
      f <= a;
    else 
      f <= 'Z';   -- "drive" the output high Z when not enabled
    end if;
  end process buff1;

  buff2: process(c, d)
  begin
    if (d = '1') then
      f <= c;
    else
      f <= 'Z';   -- "drive" the output high Z when not enabled
    end if;
  end process buff2;
end t_buff_bhv;
