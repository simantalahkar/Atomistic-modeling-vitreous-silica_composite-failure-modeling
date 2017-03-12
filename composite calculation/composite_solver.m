while 1
    start_option=input('if you want to continue with the analysis press 1 else press 2: ');
    if start_option==1
        antype=input('\nif you want to do single slab stress-strain analysis without bending press 1 \n or if you want to do multi slab analysis press 2:');
        while antype==1
            prop_op1=input('if you have the special orthrotropic properties El Et etc of the composites press 1 \n else if you have the properties of the fibres and matrix press 2:');
            flag1=2;
            while prop_op1==1
                El=input('Enter the value of longitudinal elastic modulus:');
                Et=input('Enter the value of transverse elastic modulus:');
                
                flag1=2;
                          
                Glt=input('enter the shear modulus:');
                NUlt=input('enter the major poissons ratio:');
                NUtl=Et*NUlt/El;
                                     
                break
            end
            if flag1==1
                break
            end
            while prop_op1==2
                den_opt=input('if you want to do density analysis press 1:');
                Vf=input('enter the volume fraction of fibres:');
                %Vm=input('enter the volume fraction of matrix:');
                Vm=1-Vf;
                if den_opt==1
                    RHOf=input('enter the density of fibres:');
                    RHOm=input('enter the density of matrix:');
                    composite_density=RHOf*Vf+RHOm*Vm
                end
                Ef=input('enter the elastic modulus of fibres:');
                Em=input('enter the elastic modulus of the matrix:');
                nuorG=input('for the fibres and matrix, if you know shear modulus press 1 \n or else if you know poissons ratio press 2:');
                if (nuorG~=1)&&(nuorG~=2)
                    flag1=1;
                    break
                elseif nuorG==1
                    Gf=input('enter the shear modulus of fibres:');
                    Gm=input('enter the shear modulus of the matrix:');
                    NUf=Ef/(2*Gf)-1;
                    NUm=Em/(2*Gm)-1;
                elseif nuorG==2
                    NUf=input('enter the poissons ratio for fibres:');
                    NUm=input('enter the poissons ratio for matrix:');
                    Gf=0.5*Ef/(1+NUf);
                    Gm=0.5*Em/(1+NUm);
                end
                El=Ef*Vf+Em*Vm;
                
                zeta=input('enter the value of zeta to be used in Halpin-Tsai equations (enter 2 if the fibres have circular cross-section):');
                
                etaE=((Ef/Em)-1)/((Ef/Em)+zeta);
                Et=Em*(1+zeta*etaE*Vf)/(1-etaE*Vf);
                
                etaG=((Gf/Gm)-1)/((Gf/Gm)+zeta);
                Glt=Gm*(1+zeta*etaG*Vf)/(1-etaG*Vf);
                
                NUlt=NUf*Vf+NUm*Vm;
                NUtl=Et*NUlt/El;
                
                break
            end
            if flag1==1
                break
            end
            if (prop_op1~=1)&&(prop_op1~=2)
                break
            end
            
            Composite_longitudinal_youngs_modulus=El
            Composite_transverse_youngs_modulus=Et
            Composite_shear_modulus=Glt
            Composite_major_poissons_ratio=NUlt
            Composite_minor_poissons_ratio=NUtl
            
            s=zeros(3);
            s(1,1)=1/El;
            s(1,2)=-NUtl/Et;
            s(2,1)=-NUlt/El;
            s(2,2)=1/Et;
            s(3,3)=1/Glt;
            
            theta=input('enter the angle of rotation of the composites longitudinal axis from horizontal(x-axis):');
            theta=theta*pi/180;
            t1=[(cos(theta))^2 (sin(theta))^2 2*cos(theta)*sin(theta); (sin(theta))^2 (cos(theta))^2 -2*cos(theta)*sin(theta); -cos(theta)*sin(theta) cos(theta)*sin(theta) ((cos(theta))^2-(sin(theta))^2)];
            t2=[(cos(theta))^2 (sin(theta))^2 cos(theta)*sin(theta); (sin(theta))^2 (cos(theta))^2 -cos(theta)*sin(theta); -2*cos(theta)*sin(theta) 2*cos(theta)*sin(theta) ((cos(theta))^2-(sin(theta))^2)];
            sbar=(t2\s)*t1; %inv(t2)*s=t2\s
            qbar=inv(sbar);
            
            orthrotropic_composite_compliance_matrix=sbar
            orthrotropic_composite_stiffness_matrix=qbar
            
            constrain=input('enter 1 if the stress state is input or press 2 if strain state is input:');
            
            STRESSlt=zeros(3,1);
            STRESSxy=zeros(3,1);
            STRAINlt=zeros(3,1);
            STRAINxy=zeros(3,1);            
            
            if (constrain~=1)&&(constrain~=2)
                break
            elseif constrain==1
                STRESSxy(1)=input('enter x component of stress:');
                STRESSxy(2)=input('enter y component of stress:');
                STRESSxy(3)=input('enter shear component of stress:');
                
                STRAINxy=sbar*STRESSxy;
                
                x_strain=STRAINxy(1)
                y_strain=STRAINxy(2)
                shear_strain=STRAINxy(3)
                
            elseif constrain==2
                STRAINxy(1)=input('enter x component of strain:');
                STRAINxy(2)=input('enter y component of strain:');
                STRAINxy(3)=input('enter shear component of strain:');
                
                STRESSxy=qbar*STRAINxy;
                
                x_stress=STRESSxy(1)
                y_stress=STRESSxy(2)
                shear_stress=STRESSxy(3)
                
            end
            
            fail=input('enter 1 if you have the ultimate strength values for the composite, else press 2:');
            if fail==1
                Slcu=input('enter the ultimate longitudinal compressive strength for composite:');
                Sltu=input('enter the ultimate longitudinal tensile strength for composite:');
                Stcu=input('enter the ultimate transverse compressive strength for composite:');
                Sttu=input('enter the ultimate transverse tensile strength for composite:');
                Sltu=input('enter the ultimate shear strength for composite:');
                
                %STRAINlt=t2*STRAINxy;
                STRESSlt=t1*STRESSxy;
                %compressive=-ve normal stress
                if STRESSlt(1)<0
                    sl=Slcu;
                else
                    sl=Sltu;
                end
                if STRESSlt(2)<0
                    st=Stcu;
                else
                    st=Sttu;
                end
                %Tsai-Hill theory 
                total=(STRESSlt(1)/sl)^2-(STRESSlt(1)/sl)*(STRESSlt(2)/sl)+(STRESSlt(2)/st)^2+(STRESSlt(3)/Sltu)^2
                if total <1
                    fprintf('The composite will not fail under the given stress-strain \n condition according to Tsai-Hill theory\n')
                else
                    fprintf('The composite will fail under the given stress-strain \n condition according to Tsai-Hill theory\n')
                end
            end
            break    
        end    
        while antype==2
            no_of_layers=input('Enter the total no. of layers: ');
            orientation=zeros(no_of_layers,1);
            thickness=zeros(no_of_layers,1);
            for i=1:no_of_layers
                fprintf('Layer %d \n',i)
                orientation(i)=input('Enter the orientation of layer: ');
                thickness(i)=input('Enter the thickness of layer: ');
            end
            
            total_thickness=sum(thickness);
            
            h=zeros(no_of_layers+1,1);
            for i=no_of_layers:-1:1
                h(i)=h(i+1)+thickness(i);
            end
            h=h-total_thickness/2;
            
            s=zeros(3);
            q=zeros(3);
            A=zeros(3);
            B=zeros(3);
            D=zeros(3);
            
            q_option=input('Enter 1 if Q matrix is known or Enter 2 if you only know composite properties: ');
            if (q_option~=1)&&(q_option~=2)
                break
            elseif q_option==2
                El=input('Enter the value of longitudinal elastic modulus:');
                Et=input('Enter the value of transverse elastic modulus:');
                Glt=input('enter the shear modulus:');
                NUlt=input('enter the major poissons ratio:');
                NUtl=Et*NUlt/El;
                
                
                s(1,1)=1/El;
                s(1,2)=-NUtl/Et;
                s(2,1)=-NUlt/El;
                s(2,2)=1/Et;
                s(3,3)=1/Glt;
          
                q=inv(s);
                
            elseif q_option==1
                q(1,1)=input('Enter Q11: ');
                q(1,2)=input('Enter Q12: ');
                q(2,1)=q(1,2);
                q(2,2)=input('Enter Q22: ');
                q(3,3)=input('Enter Q66: ');
                
            end
            
            for i=1:no_of_layers
                
                theta=orientation(i)*pi/180;
                t1=[(cos(theta))^2 (sin(theta))^2 2*cos(theta)*sin(theta); (sin(theta))^2 (cos(theta))^2 -2*cos(theta)*sin(theta); -cos(theta)*sin(theta) cos(theta)*sin(theta) ((cos(theta))^2-(sin(theta))^2)];
                t2=[(cos(theta))^2 (sin(theta))^2 cos(theta)*sin(theta); (sin(theta))^2 (cos(theta))^2 -cos(theta)*sin(theta); -2*cos(theta)*sin(theta) 2*cos(theta)*sin(theta) ((cos(theta))^2-(sin(theta))^2)];
                qbar=(t1\q)*t2;%inv(t1)*q=t1\q
                
                fprintf('Layer %d Orienataion %d \n',i,orientation(i));
                Orthrotropic_composite_stiffness_matrix=qbar
                
                A=A + qbar*(h(i)-h(i+1));
                B=B + 0.5*qbar*(h(i+1)^2-h(i)^2);
                D=D + 1/3*qbar*(h(i)^3-h(i+1)^3);
            end
            
            Extensional_stiffness_matrix=A
            Coupling_stiffness_matrix=B
            Bending_stiffness_matrix=D
            
            constrain=input('enter 1 if the midplane strain and plate curvature is input \n or press 2 if the normal force and moment is input:');
            
            N=zeros(3,1);
            M=zeros(3,1);
            STRAINxy=zeros(3,1);
            STRAINlt=zeros(3,1);
            STRESSxy=zeros(3,1); 
            STRESSlt=zeros(3,1);
            CURVATURExy=zeros(3,1);
            
            if (constrain~=1)&&(constrain~=2)
                break
            elseif constrain==1
                STRAINxy(1)=input('enter x component of mid plane strain:');
                STRAINxy(2)=input('enter y component of mid plane strain:');
                STRAINxy(3)=input('enter shear component of mid plane strain:');
                
                CURVATURExy(1)=input('enter x component of plate curvature:');
                CURVATURExy(2)=input('enter y component of plate curvature:');
                CURVATURExy(3)=input('enter shear component of plate curvature:');
                
                N=A*STRAINxy + B*CURVATURExy
                M=B*STRAINxy + D*CURVATURExy
                
            elseif constrain==2
                N(1)=input('enter x component of force:');
                N(2)=input('enter y component of force:');
                N(3)=input('enter shear component of force:');
                
                M(1)=input('enter x component of moment:');
                M(2)=input('enter y component of moment:');
                M(3)=input('enter shear component of moment:');
                
                Astar= inv(A);
                Bstar= -inv(A)*B;
                Cstar= -transpose(Bstar);
                Dstar=D - B*Astar*B;
                
                CURVATURExy=inv(Dstar)*M - inv(Dstar)*Cstar*N;
                K=CURVATURExy
                
                STRAINxy=(Astar-Bstar*inv(Dstar)*Cstar)*N + Bstar*inv(Dstar)*M;
                Epsilon0=STRAINxy
                
                for i=1:no_of_layers
                theta=orientation(i)*pi/180;
                t1=[(cos(theta))^2 (sin(theta))^2 2*cos(theta)*sin(theta); (sin(theta))^2 (cos(theta))^2 -2*cos(theta)*sin(theta); -cos(theta)*sin(theta) cos(theta)*sin(theta) ((cos(theta))^2-(sin(theta))^2)];
                t2=[(cos(theta))^2 (sin(theta))^2 cos(theta)*sin(theta); (sin(theta))^2 (cos(theta))^2 -cos(theta)*sin(theta); -2*cos(theta)*sin(theta) 2*cos(theta)*sin(theta) ((cos(theta))^2-(sin(theta))^2)];
                qbar=(t1\q)*t2; %inv(t1)*q=t1\q
                
                fprintf('Layer %d and orientation %d \n',i,orientation(i))
                STRESSxy=qbar*STRAINxy;
                Stress_in_xy=STRESSxy
                STRESSlt=t1*STRESSxy;
                Stress_in_lt=STRESSlt
                STRAINlt=t2*STRAINxy;
                Strain_in_lt=STRAINlt
                end
                
            end
                
            break
        end
    elseif start_option==2
        break
    end
    
end