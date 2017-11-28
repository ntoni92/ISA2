#include <iostream>
#include <stdio.h>
#include <cmath>
#include <cstring>
#include <string>

using namespace std;

int main(){
    FILE* fp;
    int i,j,N, N_BK;
    char nome_file[20];

	/*
    cout << "Inserire il numero di bit:\t";
    cin >> N;
    cout << endl;
	*/

    N = 9;

    for(i = 0; i < int(log2(N)); i++){
        N_BK = N/(pow(2,i));


        sprintf(nome_file, "VHDL/BK_%dbit.vhd", N_BK);

		/*
        nome_file_cstring = new char[nome_file.length()+1];
        strcpy(nome_file_cstring,nome_file.c_str());
		*/

        fp = fopen(nome_file, "w");
        fprintf(fp,"library ieee;\n");
        fprintf(fp,"use ieee.std_logic_1164.all;\n");
        fprintf(fp,"\n\n");

        fprintf(fp,"ENTITY BK_%dbit IS\n", N_BK);
        fprintf(fp,"\tGENERIC(N: INTEGER := %d);\n", N_BK);
        fprintf(fp,"\tPORT(\n");
        fprintf(fp,"\t\tG_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\t\tP_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\t\tG_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\t\tP_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)\n");
        fprintf(fp,"\t);\n");
        fprintf(fp,"END ENTITY;\n\n");

        fprintf(fp,"ARCHITECTURE struct OF BK_%dbit IS\n\n", N_BK);

        fprintf(fp,"\tSIGNAL Gin_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);\n");
        fprintf(fp,"\tSIGNAL Pin_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);\n");

        fprintf(fp,"\tSIGNAL GoutBK_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);\n");
        fprintf(fp,"\tSIGNAL PoutBK_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);\n");

        fprintf(fp,"\tSIGNAL Gout_lv2 : STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\tSIGNAL Pout_lv2 : STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
        fprintf(fp,"\n");

        fprintf(fp,"COMPONENT AMPERSAND IS\n");
        fprintf(fp,"\tPORT(\n");
        fprintf(fp,"\t\tGin0 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tPin0 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tGin1 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tPin1 : IN STD_LOGIC;\n");
        fprintf(fp,"\t\tGout : OUT STD_LOGIC;\n");
        fprintf(fp,"\t\tPout : OUT STD_LOGIC");
        fprintf(fp,"\n\t);\n");
        fprintf(fp,"END COMPONENT;\n\n");

        if ( i < int(log2(N)-1) ){
            fprintf(fp,"COMPONENT BK_%dbit IS\n", N_BK/2);
            fprintf(fp,"\tGENERIC(N: INTEGER := %d);\n", N_BK/2);
            fprintf(fp,"\tPORT(\n");
            fprintf(fp,"\t\tG_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
            fprintf(fp,"\t\tP_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
            fprintf(fp,"\t\tG_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);\n");
            fprintf(fp,"\t\tP_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)\n");
            fprintf(fp,"\t);\n");
            fprintf(fp,"END COMPONENT;\n\n");
        }

        // BEGIN OF ARCHITECTURE
        fprintf(fp,"BEGIN\n\n");

        // SIGNALS

        for(j=1; j<N_BK; j++){
            if(j%2){
                fprintf(fp,"\tAMP_OP_%d: AMPERSAND PORT MAP(\n",j);
                fprintf(fp,"\t\tGin0 => G_in(%d),\n", j-1);
                fprintf(fp,"\t\tPin0 => P_in(%d),\n", j-1);
                fprintf(fp,"\t\tGin1 => G_in(%d),\n", j);
                fprintf(fp,"\t\tPin1 => P_in(%d),\n", j);
                fprintf(fp,"\t\tGout => Gin_lv2(%d),\n", (j-1)/2);
                fprintf(fp,"\t\tPout => Pin_lv2(%d)\n", (j-1)/2);
                fprintf(fp,"\t);\n");
            }
            else{
                fprintf(fp,"\tAMP_OP_%d: AMPERSAND PORT MAP(\n", j);
                fprintf(fp,"\t\tGin0 => GoutBK_lv2(%d),\n", (j-2)/2);
                fprintf(fp,"\t\tPin0 => PoutBK_lv2(%d),\n", (j-2)/2);
                fprintf(fp,"\t\tGin1 => G_in(%d),\n", j);
                fprintf(fp,"\t\tPin1 => P_in(%d),\n", j);
                fprintf(fp,"\t\tGout => Gout_lv2(%d),\n", (j-2)/2);
                fprintf(fp,"\t\tPout => Pout_lv2(%d)\n", (j-2)/2);
                fprintf(fp,"\t);\n");
                fprintf(fp,"\n");
            }
        }
        fprintf(fp,"\tG_out(%d) <= G_in(%d);\n", 0, 0);
        fprintf(fp,"\tP_out(%d) <= P_in(%d);\n", 0, 0);
        fprintf(fp,"\n");

        if(i<int(log2(N))-1){
            fprintf(fp,"\tBK_Ndiv2: BK_%dbit PORT MAP(\n", N_BK/2);
            fprintf(fp,"\t\tG_in => Gin_lv2,\n");
            fprintf(fp,"\t\tP_in => Pin_lv2,\n");
            fprintf(fp,"\t\tG_out => GoutBK_lv2,\n");
            fprintf(fp,"\t\tP_out => PoutBK_lv2\n");
            fprintf(fp,"\t);\n");
            fprintf(fp,"\n");
            for(j=1; j<N_BK; j++){
                if(j%2){
                    fprintf(fp,"\tG_out(%d) <= GoutBK_lv2(%d);\n", j, (j-1)/2);
                    fprintf(fp,"\tP_out(%d) <= PoutBK_lv2(%d);\n", j, (j-1)/2);
                }
                else{
                    fprintf(fp,"\tG_out(%d) <= Gout_lv2(%d);\n", j, (j-2)/2);
                    fprintf(fp,"\tP_out(%d) <= Pout_lv2(%d);\n", j, (j-2)/2);
                }
            }
        }
        else{
            fprintf(fp,"\tG_out(%d) <= Gin_lv2(%d);\n", 1, 0);
            fprintf(fp,"\tP_out(%d) <= Pin_lv2(%d);\n", 1, 0);
        }

        fprintf(fp,"END struct;\n");

        fclose(fp);
    }
    return 0;
}
