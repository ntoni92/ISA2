#include <iostream>
#include <stdio.h>
#include <cmath>
#include <cstring>
#include <string>

using namespace std;

int main()
{
    FILE* fp;
    int i,N, N_BK;
    char nome_file[20];

	/*
    cout << "Inserire il numero di bit:\t";
    cin >> N;
    cout << endl;
	*/

    N = 12;

    for(i = 0; i < int(log2(N)); i++)
    {
        N_BK = N/(pow(2,i));


        sprintf(nome_file, "VHDL/BK_%dbit.vhd", N_BK);

		/*
        nome_file_cstring = new char[nome_file.length()+1];
        strcpy(nome_file_cstring,nome_file.c_str());
		*/

        fp = fopen(nome_file, "w");
        fprintf(fp,"ENTITY BK_%dbit IS\n", N_BK);
        fprintf(fp,"\tGENERIC(N: INTEGER := %d)\n", N_BK);
        fprintf(fp,"\tPORT(\n");
        fprintf(fp,"\t\tA: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\t\tB: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\t\tCIN : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tDOUT : OUT STD_LOGIC_VECTOR(N DOWNTO 0)\n\t);\n");
        fprintf(fp,"END ENTITY;\n\n");

        fprintf(fp,"ARCHITECTURE struct OF BK_%dbit IS\n\n", N_BK);

        fprintf(fp,"COMPONENT AMPERSAND IS\n", N_BK);
        fprintf(fp,"\tPORT(\n");
        fprintf(fp,"\t\tGin0 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tPin0 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tGin1 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tPin1 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tGout : OUT STD_LOGIC;\n");
        fprintf(fp,"\t\tPout : OUT STD_LOGIC");
        fprintf(fp,"\n\t);\n");
        fprintf(fp,"END COMPONENT;\n\n");

        if ( i < int(log2(N)-1))
        {
            fprintf(fp,"COMPONENT BK_%dbit IS\n", N_BK/2);
            fprintf(fp,"\tGENERIC(N: INTEGER := %d)\n", N_BK/2);
            fprintf(fp,"\tPORT(\n");
            fprintf(fp,"\t\tA: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
            fprintf(fp,"\t\tB: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
            fprintf(fp,"\t\tCIN : IN STD_LOGIC;\n");
            fprintf(fp,"\t\tDOUT : OUT STD_LOGIC_VECTOR(N DOWNTO 0)\n\t);\n");
            fprintf(fp,"END COMPONENT;\n\n");
        }

        fprintf(fp,"COMPONENT GP_Gen IS\n", N_BK);
        fprintf(fp,"\tPORT(\n");
        fprintf(fp,"\t\ta : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tb : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tGout : OUT STD_LOGIC;\n");
        fprintf(fp,"\t\tPout : OUT STD_LOGIC");
        fprintf(fp,"\n\t);\n");
        fprintf(fp,"END COMPONENT;\n\n");

		fprintf(fp,"COMPONENT FA IS\n");
        fprintf(fp,"\tPORT(\n");
        fprintf(fp,"\t\ta : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tb : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tc_in : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tsum : OUT STD_LOGIC;\n");
        fprintf(fp,"\t\tc_out : OUT STD_LOGIC");
        fprintf(fp,"\n\t);\n");
        fprintf(fp,"END COMPONENT;\n\n");

        fprintf(fp,"BEGIN\n\n");
        fprintf(fp,"\tSIGNAL G_array : STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\tSIGNAL P_array : STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\n");
        fprintf(fp,"\tGP_comp: FOR i IN 0 TO (N-1) GENERATE\n");
        fprintf(fp,"\t\tGP_Gen PORT MAP(\n");
        fprintf(fp,"\t\t\tA => A(i),\n");
        fprintf(fp,"\t\t\tb => B(i),\n");
        fprintf(fp,"\t\t\tGout => G_array(i),\n");
        fprintf(fp,"\t\t\tPout => P_array(i)\n");
        fprintf(fp,"\t\t);\n");
        fprintf(fp,"\tEND GENERATE;\n\n");


        fprintf(fp,"END struct;\n");

        fclose(fp);
    }
    return 0;
}
