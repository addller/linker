toc.dat                                                                                             0000600 0004000 0002000 00000246535 13307635546 0014472 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP       7                     v            linker    10.1    10.1 �    c           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false         d           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false         e           1262    17566    linker    DATABASE     �   CREATE DATABASE linker WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE linker;
             postgres    false                     2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false         f           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    4                     3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false         g           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                     3079    17614    citext 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
    DROP EXTENSION citext;
                  false    4         h           0    0    EXTENSION citext    COMMENT     S   COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';
                       false    2                    1255    18462 6   _atualizaravaliacaocomentario(bigint, bigint, boolean)    FUNCTION     �  CREATE FUNCTION _atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
    	declare
            preAvaliacao boolean;
    	begin 
        	select is_positiva into preAvaliacao from avaliacao_comentario where avaliacao_comentario.id = _id_avaliacao_comentario limit 1;
        	if(_is_positiva and not preAvaliacao) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas + 1, avaliacoes_negativas = avaliacoes_negativas - 1
                	where comentario.id = _id_comentario;
            elsif(not _is_positiva and preAvaliacao) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas - 1, avaliacoes_negativas = avaliacoes_negativas + 1
                	where comentario.id = _id_comentario;
            else
            	if(_is_positiva) then
                	update comentario set avaliacoes_positivas = avaliacoes_positivas - 1 where comentario.id = _id_comentario;
                else
                	update comentario set avaliacoes_negativas = avaliacoes_negativas - 1 where comentario.id = _id_comentario;
                end if;
             	return 'REMOVE';
            end if;
            update avaliacao_comentario set is_positiva = _is_positiva where avaliacao_comentario.id = _id_avaliacao_comentario;
            return 'TROCA';
		end
    $$;
 �   DROP FUNCTION public._atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean);
       public       postgres    false    1    4         2           1255    18472 4   _atualizaravaliacaopostagem(bigint, bigint, boolean)    FUNCTION     `  CREATE FUNCTION _atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
    	declare
            preAvaliacao boolean;
    	begin 
        	select is_positiva into preAvaliacao from avaliacao_postagem where avaliacao_postagem.id = _id_avaliacao_postagem limit 1;
        	if(_is_positiva and not preAvaliacao) then
            	update postagem set avaliacoes_positivas = avaliacoes_positivas + 1, avaliacoes_negativas = avaliacoes_negativas - 1
                	where postagem.id = _id_postagem;
            elsif(not _is_positiva and preAvaliacao) then
            	update postagem set avaliacoes_positivas = avaliacoes_positivas - 1, avaliacoes_negativas = avaliacoes_negativas + 1
                	where postagem.id = _id_postagem;
            else
            	if(_is_positiva) then
                	update postagem set avaliacoes_positivas = avaliacoes_positivas - 1 where postagem.id = _id_postagem;
                else
                	update postagem set avaliacoes_negativas = avaliacoes_negativas - 1 where postagem.id = _id_postagem;
                end if;
             	return 'REMOVE';
            end if;
            update avaliacao_postagem set is_positiva = _is_positiva where avaliacao_postagem.id = _id_avaliacao_postagem;
            return 'TROCA';
		end
    $$;
 |   DROP FUNCTION public._atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean);
       public       postgres    false    1    4                    1255    18907 '   _consultarmembrominbypostagemid(bigint)    FUNCTION     �  CREATE FUNCTION _consultarmembrominbypostagemid(_id_postagem bigint) RETURNS TABLE(id_membro bigint, nome_membro character varying, total_inscritos bigint, data_inscricao date, is_suspenso boolean, imagem_membro bytea, has_image boolean)
    LANGUAGE plpgsql
    AS $$
		declare
        	get_id bigint;
        	get_nome character varying;
        	get_total_inscritos bigint;
        	get_data_inscricao date;
       		get_is_sustenso boolean;
        	get_imagem bytea;
    	begin
        	
        	select 
            	membro.id,
        		membro.nome::character varying,
        		membro.total_inscritos,
        		membro.data_inscricao,
       			membro.is_suspenso,
        		imagem.imagem
                	into
                		get_id,
        				get_nome,
        				get_total_inscritos,
        				get_data_inscricao,
       					get_is_sustenso,
        				get_imagem    
            	from postagem, membro, album, imagem 
                	where 
                    	postagem.id = _id_postagem
                        and membro.id = postagem.id_membro_postante
                        and album.id_proprietario = postagem.id_membro_postante
                        and album.nome_album = 'perfil'
                        and album.id = imagem.id_album limit 1;  
               	return query select get_id,
        				get_nome,
        				get_total_inscritos,
        				get_data_inscricao,
       					get_is_sustenso,
        				get_imagem, get_imagem is not null;  
        end
    $$;
 K   DROP FUNCTION public._consultarmembrominbypostagemid(_id_postagem bigint);
       public       postgres    false    1    4         �            1259    17730    postagem    TABLE     o  CREATE TABLE postagem (
    id bigint NOT NULL,
    descricao citext,
    vetor_url_site character varying,
    vetor_url_video character varying,
    vetor_url_imagem character varying,
    titulo citext NOT NULL,
    patrocinador character varying(200),
    id_classificacao_etaria smallint DEFAULT 67 NOT NULL,
    id_membro_postante bigint NOT NULL,
    data_postagem timestamp(4) with time zone DEFAULT now() NOT NULL,
    visualizacoes bigint DEFAULT 0 NOT NULL,
    is_suspensa boolean DEFAULT false NOT NULL,
    avaliacoes_positivas bigint DEFAULT 0 NOT NULL,
    avaliacoes_negativas bigint DEFAULT 0 NOT NULL
);
    DROP TABLE public.postagem;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    4    2    2    4    4    2    4    2    4    2    4         �            1255    18873 =   _consultarpostagembytitulo(character varying, bigint, bigint)    FUNCTION     )  CREATE FUNCTION _consultarpostagembytitulo(_titulo character varying, _start bigint, _limit bigint) RETURNS SETOF postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from postagem where titulo like '%'||_titulo||'%' and id > _start limit _limit; 
        end
    $$;
 j   DROP FUNCTION public._consultarpostagembytitulo(_titulo character varying, _start bigint, _limit bigint);
       public       postgres    false    1    4    205         �            1259    17700    status_membro    TABLE     �   CREATE TABLE status_membro (
    nivel smallint NOT NULL,
    descricao character varying NOT NULL,
    tipo citext NOT NULL,
    id smallint NOT NULL
);
 !   DROP TABLE public.status_membro;
       public         postgres    false    4    2    2    4    4    2    4    2    4    2    4         &           1255    18500 )   _consultarstatusmembro(character varying)    FUNCTION        CREATE FUNCTION _consultarstatusmembro(_tipo character varying) RETURNS SETOF status_membro
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            return query select * from status_membro where status_membro.tipo = _tipo::citext limit 1;   
		end
    $$;
 F   DROP FUNCTION public._consultarstatusmembro(_tipo character varying);
       public       postgres    false    199    4    1         �            1255    18441 6   _denunciar(bigint, bigint, integer, character varying)    FUNCTION     -  CREATE FUNCTION _denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS TABLE(id_denuncia bigint, is_suspenso boolean)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            total_denuncias integer;
            suspensa boolean;
    	begin
        	select id into newId from registrarDenuncia(
    			_id_denunciante,
    			_id_postagem,
    			_id_tipo_denuncia,
   				_relato
            ) as id; 
             SELECT count(id) INTO total_denuncias FROM denuncia where denuncia.id_postagem = _id_postagem;
             suspensa = total_denuncias > 49;
            if(suspensa) then
            	update postagem set is_suspensa = true;
            end if;
           	return query select newId, suspensa;        
		end
    $$;
 �   DROP FUNCTION public._denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    4    1                     1255    18670 H   _editarcadastromembro(bigint, character varying, date, character, bytea)    FUNCTION     A  CREATE FUNCTION _editarcadastromembro(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _pass bytea) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    	declare
        	_id bigint;
    	begin
        	select id into _id from membro where membro.id = _id_membro and membro.pass = _pass limit 1;
            if(_id is null) then
            return false;
            end if;
        	update membro set nome = _nome, sexo = _sexo, nascimento = _nascimento 
            	where id = _id_membro and pass = _pass; 
            return true;
		end
    $$;
 �   DROP FUNCTION public._editarcadastromembro(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _pass bytea);
       public       postgres    false    4    1         �            1255    18686 E   _editarloginname(bigint, character varying, character varying, bytea)    FUNCTION     �  CREATE FUNCTION _editarloginname(_id_membro bigint, _login_name character varying, _old_login_name character varying, _pass bytea) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    	declare
            get_login_name character varying;
            get_pass bytea;
    	begin
        	select login_name, pass into get_login_name, get_pass from membro 
            	where membro.id = _id_membro limit 1;
            if(get_login_name <> _old_login_name) then
            	return 'O nome de login esta errado';
            elsif(get_pass <> _pass) THEN
            	return 'A senha esta incorreta';
            end if;
            update membro set login_name = _login_name where membro.id = _id_membro;
            return 'SUCCES';            
		end
    $$;
 �   DROP FUNCTION public._editarloginname(_id_membro bigint, _login_name character varying, _old_login_name character varying, _pass bytea);
       public       postgres    false    4    1                    1255    18683 "   _editarsenha(bigint, bytea, bytea)    FUNCTION       CREATE FUNCTION _editarsenha(_id_membro bigint, _pass bytea, _old_pass bytea) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    	declare
            get_pass character varying;
    	begin
        	select pass into get_pass from membro 
            	where membro.id = _id_membro and pass = _old_pass limit 1;
            if(get_pass is not null) then
            	update membro set pass = _pass where id = _id_membro;
            	return true;
            end if;        	 
            return false;
		end
    $$;
 T   DROP FUNCTION public._editarsenha(_id_membro bigint, _pass bytea, _old_pass bytea);
       public       postgres    false    4    1         �            1259    18750    album_postagem    TABLE     u   CREATE TABLE album_postagem (
    id_postagem bigint NOT NULL,
    img_postagem bytea,
    img_patrocinador bytea
);
 "   DROP TABLE public.album_postagem;
       public         postgres    false    4         >           1255    18916    _getalbumpostagem(bigint)    FUNCTION     �   CREATE FUNCTION _getalbumpostagem(_id_postagem bigint) RETURNS SETOF album_postagem
    LANGUAGE plpgsql
    AS $$
        begin
        	return query select * from album_postagem where id_postagem = _id_postagem limit 1;
        end
        $$;
 =   DROP FUNCTION public._getalbumpostagem(_id_postagem bigint);
       public       postgres    false    229    4    1         �            1259    17755    avaliacao_postagem    TABLE     �   CREATE TABLE avaliacao_postagem (
    id_avaliador bigint NOT NULL,
    id_postagem bigint NOT NULL,
    is_positiva boolean NOT NULL,
    id bigint NOT NULL
);
 &   DROP TABLE public.avaliacao_postagem;
       public         postgres    false    4                    1255    18871 %   _getavaliacaopostagem(bigint, bigint)    FUNCTION     ,  CREATE FUNCTION _getavaliacaopostagem(_id_avaliador bigint, _id_postagem bigint) RETURNS SETOF avaliacao_postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from avaliacao_postagem where id_postagem = _id_postagem and id_avaliador = _id_avaliador limit 1;
		end
    $$;
 W   DROP FUNCTION public._getavaliacaopostagem(_id_avaliador bigint, _id_postagem bigint);
       public       postgres    false    4    207    1         �            1259    18538    imagem    TABLE     �  CREATE TABLE imagem (
    id bigint NOT NULL,
    imagem bytea NOT NULL,
    extensao citext NOT NULL,
    titulo citext NOT NULL,
    escala citext NOT NULL,
    data_inclusao timestamp(4) with time zone DEFAULT now() NOT NULL,
    id_album bigint NOT NULL,
    CONSTRAINT imagem_escala_pequena_media_grande CHECK (((escala = 'pequena'::citext) OR (escala = 'media'::citext) OR (escala = 'grande'::citext)))
);
    DROP TABLE public.imagem;
       public         postgres    false    2    4    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    2    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    4    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    4                    1255    18608 +   _getimagemperfil(bigint, character varying)    FUNCTION       CREATE FUNCTION _getimagemperfil(_id_proprietario bigint, _escala character varying) RETURNS SETOF imagem
    LANGUAGE plpgsql
    AS $$
        	declare
            	_id_album bigint;
        	begin
            	select id into _id_album from album
                	where album.id_proprietario = _id_proprietario and album.nome_album = 'perfil' limit 1;
                
                return query select * from imagem where id_album = _id_album and escala = _escala::citext limit 1;
            end
        $$;
 [   DROP FUNCTION public._getimagemperfil(_id_proprietario bigint, _escala character varying);
       public       postgres    false    228    1    4         �            1259    18043    inscrito    TABLE        CREATE TABLE inscrito (
    id_registrando bigint NOT NULL,
    id_registrado bigint NOT NULL,
    data_inscricao date DEFAULT (now())::date NOT NULL,
    CONSTRAINT check_inscrito_registrando_difere_registrado CHECK ((id_registrando <> id_registrado))
);
    DROP TABLE public.inscrito;
       public         postgres    false    4         -           1255    18717    _getinscritos(bigint)    FUNCTION     �   CREATE FUNCTION _getinscritos(_id_membro bigint) RETURNS SETOF inscrito
    LANGUAGE plpgsql
    AS $$
    	begin 
        	return query select * from inscrito where  id_registrando = _id_membro;
		end
    $$;
 7   DROP FUNCTION public._getinscritos(_id_membro bigint);
       public       postgres    false    1    213    4                    1255    18456 -   _if_ternario(boolean, anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION _if_ternario(boolean, anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql
    AS $_$
  select case when $1 is true then $2 else $3 end;
$_$;
 D   DROP FUNCTION public._if_ternario(boolean, anyelement, anyelement);
       public       postgres    false    4         �            1259    17567    membro    TABLE     �  CREATE TABLE membro (
    login_name citext NOT NULL,
    pass bytea NOT NULL,
    email citext NOT NULL,
    is_suspenso boolean DEFAULT false NOT NULL,
    is_banido boolean DEFAULT false NOT NULL,
    sexo "char" NOT NULL,
    nascimento date NOT NULL,
    nome citext NOT NULL,
    id bigint NOT NULL,
    id_status_membro smallint DEFAULT 14 NOT NULL,
    total_inscritos bigint DEFAULT 0 NOT NULL,
    data_inscricao date DEFAULT (now())::date NOT NULL,
    acesso time with time zone DEFAULT now() NOT NULL,
    tentativas_acesso smallint DEFAULT 0 NOT NULL,
    db_key integer DEFAULT (- trunc(((random() * (999999999)::double precision) + (1357)::double precision))) NOT NULL
);
    DROP TABLE public.membro;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    4    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4         �            1255    18511     _logar(character varying, bytea)    FUNCTION     �   CREATE FUNCTION _logar(_login_name character varying, _pass bytea) RETURNS SETOF membro
    LANGUAGE plpgsql
    AS $$
    	begin
            return query select * from membro where login_name = _login_name and pass = _pass limit 1;        
		end
    $$;
 I   DROP FUNCTION public._logar(_login_name character varying, _pass bytea);
       public       postgres    false    4    197    1                    1255    18727 #   _notificarinscritos(bigint, bigint)    FUNCTION     �  CREATE FUNCTION _notificarinscritos(_id_publicador bigint, _id_postagem bigint) RETURNS TABLE(_id_inscrito bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
        	_id_registrado bigint;
    	begin 
        	for _id_registrado in select id_registrado from _getInscritos(_id_publicador) loop
            	perform registrarNotificacaoPostagem(_id_registrado,_id_postagem);
                return query select _id_registrado;
            end loop;  
  		end
    $$;
 V   DROP FUNCTION public._notificarinscritos(_id_publicador bigint, _id_postagem bigint);
       public       postgres    false    4    1                    1255    18954 )   _updatetotalvisualizacoespostagem(bigint)    FUNCTION     k  CREATE FUNCTION _updatetotalvisualizacoespostagem(_id_postagem bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
        	get_visualizacoes bigint;
    	begin 
        	update postagem set visualizacoes = visualizacoes + 1 
            	where postagem.id = _id_postagem RETURNING postagem.visualizacoes into get_visualizacoes;
            	if(mod(get_visualizacoes, 10000) = 0) then
            		insert into registro_visualizacoes(id_postagem, counter) values(_id_postagem, get_visualizacoes);
            	end if;
            return visualizacoes from postagem where id = _id_postagem;
		end
    $$;
 M   DROP FUNCTION public._updatetotalvisualizacoespostagem(_id_postagem bigint);
       public       postgres    false    4    1         �            1259    18229    notificacao_postagem    TABLE     �   CREATE TABLE notificacao_postagem (
    id_postagem bigint NOT NULL,
    id_destinatario bigint NOT NULL,
    is_pendente boolean DEFAULT true NOT NULL,
    id bigint NOT NULL
);
 (   DROP TABLE public.notificacao_postagem;
       public         postgres    false    4         +           1255    18411 7   _verificar_notificacao_postagem(bigint, bigint, bigint)    FUNCTION     l  CREATE FUNCTION _verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint) RETURNS SETOF notificacao_postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from notificacao_postagem where id_destinatario = _id_destinatario
            and id > _pre_start and is_pendente limit _limit;      
		end
    $$;
 q   DROP FUNCTION public._verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint);
       public       postgres    false    1    219    4         ;           1255    18438 >   atualizardenuncias(bigint, bigint, integer, character varying)    FUNCTION       CREATE FUNCTION atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS TABLE(id_denuncia bigint, is_suspenso boolean)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            total_denuncias integer;
    	begin
        	select id into newId from registrarDenuncia(
    			_id_denunciante,
    			_id_postagem,
    			_id_tipo_denuncia,
   				_relato
            ); 
             SELECT count(id) INTO total_denuncias FROM denuncia where denuncia.id_postagem = _id_postagem;
            if(total_denuncias > 49) then
            	update postagem set postagem.is_suspenso = true;
            end if;
           	return query select newId, total_denuncias > 49;        
		end
    $$;
 �   DROP FUNCTION public.atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    1    4         "           1255    18555 )   registraralbum(bigint, character varying)    FUNCTION     5  CREATE FUNCTION registraralbum(_id_proprietario bigint, _nome_album character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
        	select id into newId from album where id_proprietario = _id_proprietario and _nome_album::citext = 'perfil'::citext limit 1;
            if(newId is null) then
            	insert into album(id_proprietario, nome_album) 
                	values(_id_proprietario,_nome_album) returning album.id into newId;	
            end if;            
			return newId;         
		end
    $$;
 ]   DROP FUNCTION public.registraralbum(_id_proprietario bigint, _nome_album character varying);
       public       postgres    false    4    1                    1255    18766 ,   registraralbumpostagem(bigint, bytea, bytea)    FUNCTION     �  CREATE FUNCTION registraralbumpostagem(_id_postagem bigint, _img_postagem bytea, _img_patrocinador bytea) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
        begin
        	if(_img_postagem is not null or _img_patrocinador is not null) then
            	insert into album_postagem values(_id_postagem, _img_postagem, _img_patrocinador);
                return true;
            end if;
                return false;
           	end
        $$;
 p   DROP FUNCTION public.registraralbumpostagem(_id_postagem bigint, _img_postagem bytea, _img_patrocinador bytea);
       public       postgres    false    1    4         '           1255    18276 #   registraravaliacao(bigint, integer)    FUNCTION     ^  CREATE FUNCTION registraravaliacao(_id_membro_avaliador bigint, _nota integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
        insert into avaliacao(id_membro_avaliador, nota)
        	values(_id_membro_avaliador, _nota) returning avaliacao.id into newId;  
			return newId;         
		end
    $$;
 U   DROP FUNCTION public.registraravaliacao(_id_membro_avaliador bigint, _nota integer);
       public       postgres    false    1    4         �            1255    18865 3   registraravaliacaopostagem(bigint, bigint, boolean)    FUNCTION     �  CREATE FUNCTION registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean) RETURNS TABLE(_id bigint, acao text, _avaliacoes_positivas bigint, _avaliacoes_negativas bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            retorno_atualizacao text;
            get_avaliacoes_positivas bigint;
            get_avaliacoes_negativas bigint;
    	begin
        	select id into newId from avaliacao_postagem 
        		where avaliacao_postagem.id_avaliador = _id_avaliador
            		and avaliacao_postagem.id_postagem = _id_postagem limit 1;
        	if(newId is null) then        	
				insert into avaliacao_postagem(id_avaliador, id_postagem,is_positiva) values(_id_avaliador, _id_postagem,_is_positiva) returning avaliacao_postagem.id into newId; 
            	if(_is_positiva) then
            		update postagem set avaliacoes_positivas = avaliacoes_positivas + 1 where postagem.id = _id_postagem;
            	else
            		update postagem set avaliacoes_negativas = avaliacoes_negativas + 1 where postagem.id = _id_postagem;
            	end if;
        	        select avaliacoes_positivas, avaliacoes_negativas into get_avaliacoes_positivas, get_avaliacoes_negativas from postagem where postagem.id = _id_postagem limit 1;
                    return query select newId, 'REGISTRA', get_avaliacoes_positivas, get_avaliacoes_negativas;
       		else
        		select atualizacao into retorno_atualizacao from _atualizarAvaliacaopostagem( newId, _id_postagem, _is_positiva) as atualizacao;
        		if(retorno_atualizacao = 'REMOVE') then
            		delete from avaliacao_postagem where avaliacao_postagem.id = newId;
            	end if; 
        	        select avaliacoes_positivas, avaliacoes_negativas into get_avaliacoes_positivas, get_avaliacoes_negativas from postagem where postagem.id = _id_postagem limit 1;
	            	return query select newId,retorno_atualizacao, get_avaliacoes_positivas, get_avaliacoes_negativas;
        	end if;        
		end
    $$;
 r   DROP FUNCTION public.registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean);
       public       postgres    false    1    4         9           1255    18098 8   registrarcategoria(character varying, character varying)    FUNCTION     Z  CREATE FUNCTION registrarcategoria(_tipo character varying, _descricao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into categoria(tipo, descricao)
            values(_tipo, _descricao) returning categoria.id into newId;
			return newId;         
		end
    $$;
 `   DROP FUNCTION public.registrarcategoria(_tipo character varying, _descricao character varying);
       public       postgres    false    1    4         1           1255    18690 g   registrarclassificacaoetaria(integer, character varying, character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION registrarclassificacaoetaria(_id integer, _classificacao character varying, _tipo character varying, _codigo character varying, _idade integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into classificacao_etaria(id,classificacao, tipo, codigo, idade)
            values(_id, _classificacao, _tipo, _codigo, _idade) returning classificacao_etaria.id into newId;
			return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrarclassificacaoetaria(_id integer, _classificacao character varying, _tipo character varying, _codigo character varying, _idade integer);
       public       postgres    false    4    1                    1255    18829 6   registrarcomentario(character varying, bigint, bigint)    FUNCTION     t  CREATE FUNCTION registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint) RETURNS TABLE(_id bigint, _data_comentario timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
    	declare
    		get_id bigint;
            get_data_comentario timestamp with time zone;
    	begin
            insert into comentario(comentario, id_remetente, id_postagem) 
            	values(_comentario, _id_remetente, _id_postagem) 
                	returning comentario.id, comentario.data_comentario into get_id, get_data_comentario;
			return query select get_id,get_data_comentario;         
		end
    $$;
 t   DROP FUNCTION public.registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint);
       public       postgres    false    1    4                    1255    18221 =   registrardenuncia(bigint, bigint, integer, character varying)    FUNCTION     (  CREATE FUNCTION registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
        	select id into newId from denuncia 
            		where denuncia.id_denunciante = _id_denunciante
                    	and denuncia.id_postagem = _id_postagem
                        	and denuncia.id_tipo_denuncia = _id_tipo_denuncia limit 1;
                            
            	if(newId is null) then 
            		insert into denuncia(id_denunciante, id_postagem, id_tipo_denuncia, relato) 
            			values(_id_denunciante, _id_postagem, _id_tipo_denuncia, _relato) returning denuncia.id into newId;
				end if;
            return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    1    4                    1255    18167 H   registrardenuncia(bigint, character varying, integer, character varying)    FUNCTION     �  CREATE FUNCTION registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into denuncia(id_denunciante, id_postagem, id_tipo_denuncia, relato) 
            	values(_id_denunciante, _id_postagem, _id_tipo_denuncia, _relato) returning denuncia.id into newId;
			return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    1    4         .           1255    18569 W   registrarimagem(bigint, bytea, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION registrarimagem(_id_album bigint, _imagem bytea, _extensao character varying, _titulo character varying, _escala character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
            insert into imagem(id_album, imagem, extensao,titulo,escala)
            values(_id_album, _imagem, _extensao,_titulo,_escala) returning imagem.id into newId;
			return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrarimagem(_id_album bigint, _imagem bytea, _extensao character varying, _titulo character varying, _escala character varying);
       public       postgres    false    1    4         �            1255    18577 7   registrarimagemperfil(bigint, bytea, character varying)    FUNCTION     Q  CREATE FUNCTION registrarimagemperfil(_id_proprietario bigint, _imagem bytea, _escala character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare 
        _id_album bigint;
        newId bigint;
        
        begin
        	select id into _id_album from album where id_proprietario = _id_proprietario and nome_album = 'perfil' limit 1;
            select id into newId from imagem where id_album = _id_album and escala = _escala;
            if(newId is null) then
            	insert into imagem(id_album, imagem, titulo,escala, extensao)
                	values(_id_album, _imagem, 'perfil',_escala, 'jpg') returning imagem.id into newId;
            else
            	update imagem set imagem = _imagem where id_album = _id_album and escala = _escala;
            end if;
            return newId;
        end
        $$;
 o   DROP FUNCTION public.registrarimagemperfil(_id_proprietario bigint, _imagem bytea, _escala character varying);
       public       postgres    false    1    4         �            1255    18921 !   registrarinscrito(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarinscrito(_id_registrando bigint, _id_registrado bigint) RETURNS TABLE(registro boolean, _total_inscritos bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
        	isRegistrado bigint;
    	begin 
        	if(_id_registrando <> _id_registrado) then 
            	select _id_registrado into isRegistrado from inscrito 
            		where inscrito.id_registrado = _id_registrado and inscrito.id_registrando = _id_registrando limit 1;                
                if(isRegistrado is null) then
            		insert into inscrito(id_registrando, id_registrado) values(_id_registrando, _id_registrado);
                    update membro set total_inscritos = total_inscritos + 1 where id = _id_registrando;
                else
                	update membro set total_inscritos = total_inscritos - 1 where id = _id_registrando;
                    delete from inscrito where id_registrando = _id_registrando and id_registrado = _id_registrado;
                end if;	
            end if; 
            return query select isRegistrado is null,(select total_inscritos from membro where id = _id_registrando limit 1);
		end
    $$;
 W   DROP FUNCTION public.registrarinscrito(_id_registrando bigint, _id_registrado bigint);
       public       postgres    false    1    4         8           1255    18777 `   registrarmembro(character varying, date, character, character varying, bytea, character varying)    FUNCTION     |  CREATE FUNCTION registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying) RETURNS TABLE(_id_membro bigint, _db_key bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            db_key bigint;
    	begin
            insert into membro(login_name, pass, email, sexo, nascimento, nome)
            values(_login_name, _pass, _email, _sexo, _nascimento, _nome) returning membro.id, membro.db_key into newId, db_key;
            perform registrarAlbum(newId, 'perfil');
			return query select newId, db_key;         
		end
    $$;
 �   DROP FUNCTION public.registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying);
       public       postgres    false    4    1         <           1255    18383 .   registrarnotificacaocomentario(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare        
        	newId bigint;
    	begin 
        	insert into notificacao_comentario(id_comentario, id_destinatario) 
            	values(_id_comentario, _id_destinatario) returning notificacao_comentario.id into newId;
			return newId; 
		end
    $$;
 e   DROP FUNCTION public.registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint);
       public       postgres    false    4    1                     1255    18726 ,   registrarnotificacaopostagem(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare        
        	newId bigint;
    	begin 
        	insert into notificacao_postagem(id_postagem, id_destinatario) 
            	values(_id_postagem, _id_destinatario) returning notificacao_postagem.id into newId;
			return newId; 
		end
    $$;
 a   DROP FUNCTION public.registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint);
       public       postgres    false    4    1         #           1255    18820 �   registrarpostagem(bigint, character varying, character varying[], character varying[], character varying[], character varying, character varying)    FUNCTION     �  CREATE FUNCTION registrarpostagem(_id_membro_postante bigint, _descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _titulo character varying, _patrocinador character varying) RETURNS TABLE(_id bigint, _visualizacoes bigint, _avaliacoes_positivas bigint, _avaliacoes_negativas bigint, _is_suspensa boolean, _data_postagem date)
    LANGUAGE plpgsql
    AS $$
    declare
    get_id bigint;
    get_visualizacoes bigint;
    get_avaliacoes_positivas bigint;
    get_avaliacoes_negativas bigint;
    get_is_suspensa boolean;
    get_data_postagem date;
    begin
    insert into postagem(
        	descricao, 
        	vetor_url_site,
        	vetor_url_video,
        	vetor_url_imagem,
        	titulo,
        	patrocinador,
        	id_membro_postante	
    		)
            	values(	
                    _descricao, 
                    _vetor_url_site, 
                    _vetor_url_video,
                    _vetor_url_imagem,
                    _titulo,
                    _patrocinador,
                    _id_membro_postante
                ) 
            	returning 
                	postagem.id, 
                    postagem.visualizacoes, 
                    postagem.avaliacoes_positivas,
                    postagem.avaliacoes_negativas,
                    postagem.is_suspensa,
                    postagem.data_postagem 
                    	into 
                        	get_id,
                            get_visualizacoes,
                            get_avaliacoes_positivas,
                            get_avaliacoes_negativas,
                            get_is_suspensa,
                            get_data_postagem;
			return query select get_id,
                            get_visualizacoes,
                            get_avaliacoes_positivas,
                            get_avaliacoes_negativas,
                            get_is_suspensa,
                            get_data_postagem;         
		end
    $$;
   DROP FUNCTION public.registrarpostagem(_id_membro_postante bigint, _descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _titulo character varying, _patrocinador character varying);
       public       postgres    false    1    4         $           1255    18163 ;   registrartipodenuncia(character varying, character varying)    FUNCTION     Y  CREATE FUNCTION registrartipodenuncia(_tipo character varying, _descricao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into tipo_denuncia(tipo, descricao) values(_tipo, _descricao) returning tipo_denuncia.id into newId;
			return newId;         
		end
    $$;
 c   DROP FUNCTION public.registrartipodenuncia(_tipo character varying, _descricao character varying);
       public       postgres    false    4    1         �            1259    18522    album    TABLE     �   CREATE TABLE album (
    id bigint NOT NULL,
    id_proprietario bigint NOT NULL,
    data_criacao timestamp with time zone DEFAULT now() NOT NULL,
    total_imagens integer DEFAULT 0 NOT NULL,
    nome_album citext NOT NULL
);
    DROP TABLE public.album;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    4         �            1259    18520    album_id_seq    SEQUENCE     n   CREATE SEQUENCE album_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.album_id_seq;
       public       postgres    false    4    226         i           0    0    album_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE album_id_seq OWNED BY album.id;
            public       postgres    false    225         �            1259    17760    avaliacao_comentario    TABLE     �   CREATE TABLE avaliacao_comentario (
    id_avaliador bigint NOT NULL,
    id_comentario bigint NOT NULL,
    is_positiva boolean NOT NULL,
    id bigint NOT NULL
);
 (   DROP TABLE public.avaliacao_comentario;
       public         postgres    false    4         �            1259    18307    avaliacao_comentario_id_seq    SEQUENCE     }   CREATE SEQUENCE avaliacao_comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.avaliacao_comentario_id_seq;
       public       postgres    false    4    208         j           0    0    avaliacao_comentario_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE avaliacao_comentario_id_seq OWNED BY avaliacao_comentario.id;
            public       postgres    false    221         �            1259    18315    avaliacao_postagem_id_seq    SEQUENCE     {   CREATE SEQUENCE avaliacao_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.avaliacao_postagem_id_seq;
       public       postgres    false    207    4         k           0    0    avaliacao_postagem_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE avaliacao_postagem_id_seq OWNED BY avaliacao_postagem.id;
            public       postgres    false    222         �            1259    17778 	   categoria    TABLE     y   CREATE TABLE categoria (
    tipo citext NOT NULL,
    descricao character varying NOT NULL,
    id smallint NOT NULL
);
    DROP TABLE public.categoria;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    4         �            1259    18085    categoria_id_seq    SEQUENCE     �   CREATE SEQUENCE categoria_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.categoria_id_seq;
       public       postgres    false    209    4         l           0    0    categoria_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE categoria_id_seq OWNED BY categoria.id;
            public       postgres    false    217         �            1259    18070    categoria_postagem    TABLE     �   CREATE TABLE categoria_postagem (
    id bigint NOT NULL,
    id_categoria_partilhada smallint NOT NULL,
    id_postagem bigint NOT NULL
);
 &   DROP TABLE public.categoria_postagem;
       public         postgres    false    4         �            1259    18068 "   categoria_postagem_id_postagem_seq    SEQUENCE     �   CREATE SEQUENCE categoria_postagem_id_postagem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.categoria_postagem_id_postagem_seq;
       public       postgres    false    4    216         m           0    0 "   categoria_postagem_id_postagem_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE categoria_postagem_id_postagem_seq OWNED BY categoria_postagem.id_postagem;
            public       postgres    false    215         �            1259    18066    categoria_postagem_id_seq    SEQUENCE     {   CREATE SEQUENCE categoria_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.categoria_postagem_id_seq;
       public       postgres    false    216    4         n           0    0    categoria_postagem_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE categoria_postagem_id_seq OWNED BY categoria_postagem.id;
            public       postgres    false    214         �            1259    17786    classificacao_etaria    TABLE     �   CREATE TABLE classificacao_etaria (
    tipo citext NOT NULL,
    idade smallint NOT NULL,
    id smallint NOT NULL,
    classificacao citext NOT NULL,
    codigo citext NOT NULL
);
 (   DROP TABLE public.classificacao_etaria;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    4         �            1259    18015    classificacao_etaria_id_seq    SEQUENCE     �   CREATE SEQUENCE classificacao_etaria_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.classificacao_etaria_id_seq;
       public       postgres    false    4    210         o           0    0    classificacao_etaria_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE classificacao_etaria_id_seq OWNED BY classificacao_etaria.id;
            public       postgres    false    212         �            1259    17718 
   comentario    TABLE     v  CREATE TABLE comentario (
    id bigint NOT NULL,
    is_editado boolean DEFAULT false NOT NULL,
    data_comentario timestamp(4) with time zone DEFAULT now() NOT NULL,
    comentario citext NOT NULL,
    id_postagem bigint NOT NULL,
    id_remetente bigint NOT NULL,
    avaliacoes_positivas bigint DEFAULT 0 NOT NULL,
    avaliacoes_negativas bigint DEFAULT 0 NOT NULL
);
    DROP TABLE public.comentario;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    4         �            1259    17716    comentario_id_seq    SEQUENCE     s   CREATE SEQUENCE comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.comentario_id_seq;
       public       postgres    false    4    203         p           0    0    comentario_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE comentario_id_seq OWNED BY comentario.id;
            public       postgres    false    202         �            1259    17710    denuncia    TABLE       CREATE TABLE denuncia (
    id bigint NOT NULL,
    id_denunciante bigint NOT NULL,
    id_postagem bigint NOT NULL,
    id_tipo_denuncia smallint NOT NULL,
    relato character varying(300),
    data_denuncia timestamp(4) with time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.denuncia;
       public         postgres    false    4         �            1259    17708    denuncia_id_seq    SEQUENCE     q   CREATE SEQUENCE denuncia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.denuncia_id_seq;
       public       postgres    false    4    201         q           0    0    denuncia_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE denuncia_id_seq OWNED BY denuncia.id;
            public       postgres    false    200         �            1259    18536    imagens_id_seq    SEQUENCE     p   CREATE SEQUENCE imagens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imagens_id_seq;
       public       postgres    false    228    4         r           0    0    imagens_id_seq    SEQUENCE OWNED BY     2   ALTER SEQUENCE imagens_id_seq OWNED BY imagem.id;
            public       postgres    false    227         �            1259    17603    membro_id_seq    SEQUENCE     o   CREATE SEQUENCE membro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.membro_id_seq;
       public       postgres    false    4    197         s           0    0    membro_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE membro_id_seq OWNED BY membro.id;
            public       postgres    false    198         �            1259    18244    notificacao_comentario    TABLE     �   CREATE TABLE notificacao_comentario (
    id bigint NOT NULL,
    id_comentario bigint NOT NULL,
    id_destinatario bigint NOT NULL,
    is_pendente boolean DEFAULT true NOT NULL
);
 *   DROP TABLE public.notificacao_comentario;
       public         postgres    false    4         �            1259    18348    notificacao_comentario_id_seq    SEQUENCE        CREATE SEQUENCE notificacao_comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.notificacao_comentario_id_seq;
       public       postgres    false    220    4         t           0    0    notificacao_comentario_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE notificacao_comentario_id_seq OWNED BY notificacao_comentario.id;
            public       postgres    false    223         �            1259    18385    notificacao_postagem_id_seq    SEQUENCE     }   CREATE SEQUENCE notificacao_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.notificacao_postagem_id_seq;
       public       postgres    false    4    219         u           0    0    notificacao_postagem_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE notificacao_postagem_id_seq OWNED BY notificacao_postagem.id;
            public       postgres    false    224         �            1259    17728    postagem_id_seq    SEQUENCE     q   CREATE SEQUENCE postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.postagem_id_seq;
       public       postgres    false    205    4         v           0    0    postagem_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE postagem_id_seq OWNED BY postagem.id;
            public       postgres    false    204         �            1259    18931    registro_visualizacoes    TABLE     �   CREATE TABLE registro_visualizacoes (
    id_postagem bigint NOT NULL,
    data_registro timestamp(4) with time zone DEFAULT now() NOT NULL,
    counter bigint NOT NULL,
    id bigint NOT NULL
);
 *   DROP TABLE public.registro_visualizacoes;
       public         postgres    false    4         �            1259    18945    registro_visualizacoes_id_seq    SEQUENCE        CREATE SEQUENCE registro_visualizacoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.registro_visualizacoes_id_seq;
       public       postgres    false    230    4         w           0    0    registro_visualizacoes_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE registro_visualizacoes_id_seq OWNED BY registro_visualizacoes.id;
            public       postgres    false    231         �            1259    17986    status_membro_id_seq    SEQUENCE     �   CREATE SEQUENCE status_membro_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.status_membro_id_seq;
       public       postgres    false    199    4         x           0    0    status_membro_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE status_membro_id_seq OWNED BY status_membro.id;
            public       postgres    false    211         �            1259    17739    tipo_denuncia    TABLE     r   CREATE TABLE tipo_denuncia (
    id smallint NOT NULL,
    tipo citext NOT NULL,
    descricao citext NOT NULL
);
 !   DROP TABLE public.tipo_denuncia;
       public         postgres    false    2    2    4    4    2    4    2    4    2    4    2    2    4    4    2    4    2    4    2    4    4         �            1259    18147    tipo_denuncia_id_seq    SEQUENCE     �   CREATE SEQUENCE tipo_denuncia_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tipo_denuncia_id_seq;
       public       postgres    false    206    4         y           0    0    tipo_denuncia_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE tipo_denuncia_id_seq OWNED BY tipo_denuncia.id;
            public       postgres    false    218         u           2604    18525    album id    DEFAULT     V   ALTER TABLE ONLY album ALTER COLUMN id SET DEFAULT nextval('album_id_seq'::regclass);
 7   ALTER TABLE public.album ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    226    225    226         j           2604    18309    avaliacao_comentario id    DEFAULT     t   ALTER TABLE ONLY avaliacao_comentario ALTER COLUMN id SET DEFAULT nextval('avaliacao_comentario_id_seq'::regclass);
 F   ALTER TABLE public.avaliacao_comentario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    221    208         i           2604    18317    avaliacao_postagem id    DEFAULT     p   ALTER TABLE ONLY avaliacao_postagem ALTER COLUMN id SET DEFAULT nextval('avaliacao_postagem_id_seq'::regclass);
 D   ALTER TABLE public.avaliacao_postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    207         k           2604    18087    categoria id    DEFAULT     ^   ALTER TABLE ONLY categoria ALTER COLUMN id SET DEFAULT nextval('categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    217    209         p           2604    18115    categoria_postagem id    DEFAULT     p   ALTER TABLE ONLY categoria_postagem ALTER COLUMN id SET DEFAULT nextval('categoria_postagem_id_seq'::regclass);
 D   ALTER TABLE public.categoria_postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    216    214    216         o           2604    18074    categoria_postagem id_postagem    DEFAULT     �   ALTER TABLE ONLY categoria_postagem ALTER COLUMN id_postagem SET DEFAULT nextval('categoria_postagem_id_postagem_seq'::regclass);
 M   ALTER TABLE public.categoria_postagem ALTER COLUMN id_postagem DROP DEFAULT;
       public       postgres    false    215    216    216         l           2604    18017    classificacao_etaria id    DEFAULT     t   ALTER TABLE ONLY classificacao_etaria ALTER COLUMN id SET DEFAULT nextval('classificacao_etaria_id_seq'::regclass);
 F   ALTER TABLE public.classificacao_etaria ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    210         \           2604    17725    comentario id    DEFAULT     `   ALTER TABLE ONLY comentario ALTER COLUMN id SET DEFAULT nextval('comentario_id_seq'::regclass);
 <   ALTER TABLE public.comentario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    203    203         Z           2604    17713    denuncia id    DEFAULT     \   ALTER TABLE ONLY denuncia ALTER COLUMN id SET DEFAULT nextval('denuncia_id_seq'::regclass);
 :   ALTER TABLE public.denuncia ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    200    201    201         x           2604    18541 	   imagem id    DEFAULT     Y   ALTER TABLE ONLY imagem ALTER COLUMN id SET DEFAULT nextval('imagens_id_seq'::regclass);
 8   ALTER TABLE public.imagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    228    227    228         O           2604    17605 	   membro id    DEFAULT     X   ALTER TABLE ONLY membro ALTER COLUMN id SET DEFAULT nextval('membro_id_seq'::regclass);
 8   ALTER TABLE public.membro ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    197         s           2604    18350    notificacao_comentario id    DEFAULT     x   ALTER TABLE ONLY notificacao_comentario ALTER COLUMN id SET DEFAULT nextval('notificacao_comentario_id_seq'::regclass);
 H   ALTER TABLE public.notificacao_comentario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    223    220         r           2604    18387    notificacao_postagem id    DEFAULT     t   ALTER TABLE ONLY notificacao_postagem ALTER COLUMN id SET DEFAULT nextval('notificacao_postagem_id_seq'::regclass);
 F   ALTER TABLE public.notificacao_postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    224    219         a           2604    17733    postagem id    DEFAULT     \   ALTER TABLE ONLY postagem ALTER COLUMN id SET DEFAULT nextval('postagem_id_seq'::regclass);
 :   ALTER TABLE public.postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    205    205         {           2604    18947    registro_visualizacoes id    DEFAULT     x   ALTER TABLE ONLY registro_visualizacoes ALTER COLUMN id SET DEFAULT nextval('registro_visualizacoes_id_seq'::regclass);
 H   ALTER TABLE public.registro_visualizacoes ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    231    230         Y           2604    17988    status_membro id    DEFAULT     f   ALTER TABLE ONLY status_membro ALTER COLUMN id SET DEFAULT nextval('status_membro_id_seq'::regclass);
 ?   ALTER TABLE public.status_membro ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    199         h           2604    18149    tipo_denuncia id    DEFAULT     f   ALTER TABLE ONLY tipo_denuncia ALTER COLUMN id SET DEFAULT nextval('tipo_denuncia_id_seq'::regclass);
 ?   ALTER TABLE public.tipo_denuncia ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    218    206         [          0    18522    album 
   TABLE DATA               V   COPY album (id, id_proprietario, data_criacao, total_imagens, nome_album) FROM stdin;
    public       postgres    false    226       3163.dat ^          0    18750    album_postagem 
   TABLE DATA               N   COPY album_postagem (id_postagem, img_postagem, img_patrocinador) FROM stdin;
    public       postgres    false    229       3166.dat I          0    17760    avaliacao_comentario 
   TABLE DATA               U   COPY avaliacao_comentario (id_avaliador, id_comentario, is_positiva, id) FROM stdin;
    public       postgres    false    208       3145.dat H          0    17755    avaliacao_postagem 
   TABLE DATA               Q   COPY avaliacao_postagem (id_avaliador, id_postagem, is_positiva, id) FROM stdin;
    public       postgres    false    207       3144.dat J          0    17778 	   categoria 
   TABLE DATA               1   COPY categoria (tipo, descricao, id) FROM stdin;
    public       postgres    false    209       3146.dat Q          0    18070    categoria_postagem 
   TABLE DATA               O   COPY categoria_postagem (id, id_categoria_partilhada, id_postagem) FROM stdin;
    public       postgres    false    216       3153.dat K          0    17786    classificacao_etaria 
   TABLE DATA               O   COPY classificacao_etaria (tipo, idade, id, classificacao, codigo) FROM stdin;
    public       postgres    false    210       3147.dat D          0    17718 
   comentario 
   TABLE DATA               �   COPY comentario (id, is_editado, data_comentario, comentario, id_postagem, id_remetente, avaliacoes_positivas, avaliacoes_negativas) FROM stdin;
    public       postgres    false    203       3140.dat B          0    17710    denuncia 
   TABLE DATA               e   COPY denuncia (id, id_denunciante, id_postagem, id_tipo_denuncia, relato, data_denuncia) FROM stdin;
    public       postgres    false    201       3138.dat ]          0    18538    imagem 
   TABLE DATA               X   COPY imagem (id, imagem, extensao, titulo, escala, data_inclusao, id_album) FROM stdin;
    public       postgres    false    228       3165.dat N          0    18043    inscrito 
   TABLE DATA               J   COPY inscrito (id_registrando, id_registrado, data_inscricao) FROM stdin;
    public       postgres    false    213       3150.dat >          0    17567    membro 
   TABLE DATA               �   COPY membro (login_name, pass, email, is_suspenso, is_banido, sexo, nascimento, nome, id, id_status_membro, total_inscritos, data_inscricao, acesso, tentativas_acesso, db_key) FROM stdin;
    public       postgres    false    197       3134.dat U          0    18244    notificacao_comentario 
   TABLE DATA               Z   COPY notificacao_comentario (id, id_comentario, id_destinatario, is_pendente) FROM stdin;
    public       postgres    false    220       3157.dat T          0    18229    notificacao_postagem 
   TABLE DATA               V   COPY notificacao_postagem (id_postagem, id_destinatario, is_pendente, id) FROM stdin;
    public       postgres    false    219       3156.dat F          0    17730    postagem 
   TABLE DATA               �   COPY postagem (id, descricao, vetor_url_site, vetor_url_video, vetor_url_imagem, titulo, patrocinador, id_classificacao_etaria, id_membro_postante, data_postagem, visualizacoes, is_suspensa, avaliacoes_positivas, avaliacoes_negativas) FROM stdin;
    public       postgres    false    205       3142.dat _          0    18931    registro_visualizacoes 
   TABLE DATA               R   COPY registro_visualizacoes (id_postagem, data_registro, counter, id) FROM stdin;
    public       postgres    false    230       3167.dat @          0    17700    status_membro 
   TABLE DATA               <   COPY status_membro (nivel, descricao, tipo, id) FROM stdin;
    public       postgres    false    199       3136.dat G          0    17739    tipo_denuncia 
   TABLE DATA               5   COPY tipo_denuncia (id, tipo, descricao) FROM stdin;
    public       postgres    false    206       3143.dat z           0    0    album_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('album_id_seq', 88, true);
            public       postgres    false    225         {           0    0    avaliacao_comentario_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('avaliacao_comentario_id_seq', 112, true);
            public       postgres    false    221         |           0    0    avaliacao_postagem_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('avaliacao_postagem_id_seq', 174, true);
            public       postgres    false    222         }           0    0    categoria_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('categoria_id_seq', 13, true);
            public       postgres    false    217         ~           0    0 "   categoria_postagem_id_postagem_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('categoria_postagem_id_postagem_seq', 1, false);
            public       postgres    false    215                    0    0    categoria_postagem_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('categoria_postagem_id_seq', 1, true);
            public       postgres    false    214         �           0    0    classificacao_etaria_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('classificacao_etaria_id_seq', 1, true);
            public       postgres    false    212         �           0    0    comentario_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('comentario_id_seq', 86, true);
            public       postgres    false    202         �           0    0    denuncia_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('denuncia_id_seq', 9, true);
            public       postgres    false    200         �           0    0    imagens_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imagens_id_seq', 99, true);
            public       postgres    false    227         �           0    0    membro_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('membro_id_seq', 157, true);
            public       postgres    false    198         �           0    0    notificacao_comentario_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('notificacao_comentario_id_seq', 4, true);
            public       postgres    false    223         �           0    0    notificacao_postagem_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('notificacao_postagem_id_seq', 582, true);
            public       postgres    false    224         �           0    0    postagem_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('postagem_id_seq', 210, true);
            public       postgres    false    204         �           0    0    registro_visualizacoes_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('registro_visualizacoes_id_seq', 14, true);
            public       postgres    false    231         �           0    0    status_membro_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('status_membro_id_seq', 19, true);
            public       postgres    false    211         �           0    0    tipo_denuncia_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('tipo_denuncia_id_seq', 3, true);
            public       postgres    false    218         �           2606    18530    album album_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.album DROP CONSTRAINT album_pkey;
       public         postgres    false    226         �           2606    18757 "   album_postagem album_postagem_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY album_postagem
    ADD CONSTRAINT album_postagem_pkey PRIMARY KEY (id_postagem);
 L   ALTER TABLE ONLY public.album_postagem DROP CONSTRAINT album_postagem_pkey;
       public         postgres    false    229         �           2606    18314 .   avaliacao_comentario avaliacao_comentario_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT avaliacao_comentario_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT avaliacao_comentario_pkey;
       public         postgres    false    208         �           2606    18322 *   avaliacao_postagem avaliacao_postagem_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT avaliacao_postagem_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT avaliacao_postagem_pkey;
       public         postgres    false    207         �           2606    18095    categoria categoria_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public         postgres    false    209         �           2606    18117 *   categoria_postagem categoria_postagem_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT categoria_postagem_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT categoria_postagem_pkey;
       public         postgres    false    216         X           2606    18427    membro check_membro_menor_idade    CHECK CONSTRAINT     �   ALTER TABLE membro
    ADD CONSTRAINT check_membro_menor_idade CHECK ((date_part('years'::text, age((nascimento)::timestamp with time zone)) > (17)::double precision)) NOT VALID;
 D   ALTER TABLE public.membro DROP CONSTRAINT check_membro_menor_idade;
       public       postgres    false    197    197         �           2606    18027 .   classificacao_etaria classificacao_etaria_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT classificacao_etaria_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT classificacao_etaria_pkey;
       public         postgres    false    210         �           2606    17727    comentario comentario_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.comentario DROP CONSTRAINT comentario_pkey;
       public         postgres    false    203         �           2606    17715    denuncia denuncia_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT denuncia_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT denuncia_pkey;
       public         postgres    false    201         �           2606    18547    imagem imagens_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY imagem
    ADD CONSTRAINT imagens_pkey PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.imagem DROP CONSTRAINT imagens_pkey;
       public         postgres    false    228         ~           2606    17613    membro membro_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY membro
    ADD CONSTRAINT membro_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.membro DROP CONSTRAINT membro_pkey;
       public         postgres    false    197         �           2606    18355 2   notificacao_comentario notificacao_comentario_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT notificacao_comentario_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT notificacao_comentario_pkey;
       public         postgres    false    220         �           2606    18392 .   notificacao_postagem notificacao_postagem_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT notificacao_postagem_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT notificacao_postagem_pkey;
       public         postgres    false    219         �           2606    17738    postagem postagem_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY postagem
    ADD CONSTRAINT postagem_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.postagem DROP CONSTRAINT postagem_pkey;
       public         postgres    false    205         �           2606    18952 2   registro_visualizacoes registro_visualizacoes_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY registro_visualizacoes
    ADD CONSTRAINT registro_visualizacoes_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.registro_visualizacoes DROP CONSTRAINT registro_visualizacoes_pkey;
       public         postgres    false    230         �           2606    17998     status_membro status_membro_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_pkey;
       public         postgres    false    199         �           2606    17960 (   status_membro status_membro_unique_nivel 
   CONSTRAINT     ]   ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_unique_nivel UNIQUE (nivel);
 R   ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_unique_nivel;
       public         postgres    false    199         �           2606    17962 '   status_membro status_membro_unique_tipo 
   CONSTRAINT     [   ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_unique_tipo UNIQUE (tipo);
 Q   ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_unique_tipo;
       public         postgres    false    199         �           2606    18157     tipo_denuncia tipo_denuncia_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY tipo_denuncia
    ADD CONSTRAINT tipo_denuncia_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_denuncia DROP CONSTRAINT tipo_denuncia_pkey;
       public         postgres    false    206         �           2606    18097    categoria unique_categoria_tipo 
   CONSTRAINT     S   ALTER TABLE ONLY categoria
    ADD CONSTRAINT unique_categoria_tipo UNIQUE (tipo);
 I   ALTER TABLE ONLY public.categoria DROP CONSTRAINT unique_categoria_tipo;
       public         postgres    false    209         �           2606    18688 6   classificacao_etaria unique_classificaca_etaria_codigo 
   CONSTRAINT     l   ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT unique_classificaca_etaria_codigo UNIQUE (codigo);
 `   ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT unique_classificaca_etaria_codigo;
       public         postgres    false    210         �           2606    17956    membro unique_membro_email 
   CONSTRAINT     O   ALTER TABLE ONLY membro
    ADD CONSTRAINT unique_membro_email UNIQUE (email);
 D   ALTER TABLE ONLY public.membro DROP CONSTRAINT unique_membro_email;
       public         postgres    false    197         �           2606    17954    membro unique_membro_login_name 
   CONSTRAINT     Y   ALTER TABLE ONLY membro
    ADD CONSTRAINT unique_membro_login_name UNIQUE (login_name);
 I   ALTER TABLE ONLY public.membro DROP CONSTRAINT unique_membro_login_name;
       public         postgres    false    197         �           2606    18159 "   tipo_denuncia unique_tipo_denuncia 
   CONSTRAINT     V   ALTER TABLE ONLY tipo_denuncia
    ADD CONSTRAINT unique_tipo_denuncia UNIQUE (tipo);
 L   ALTER TABLE ONLY public.tipo_denuncia DROP CONSTRAINT unique_tipo_denuncia;
       public         postgres    false    206         �           2606    18758 &   album_postagem album_postagem_postagem    FK CONSTRAINT     ~   ALTER TABLE ONLY album_postagem
    ADD CONSTRAINT album_postagem_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 P   ALTER TABLE ONLY public.album_postagem DROP CONSTRAINT album_postagem_postagem;
       public       postgres    false    2958    229    205         �           2606    18556    album fk_album_proprietario    FK CONSTRAINT     u   ALTER TABLE ONLY album
    ADD CONSTRAINT fk_album_proprietario FOREIGN KEY (id_proprietario) REFERENCES membro(id);
 E   ALTER TABLE ONLY public.album DROP CONSTRAINT fk_album_proprietario;
       public       postgres    false    226    2942    197         �           2606    18283 ,   avaliacao_comentario fk_avaliacao_comentario    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT fk_avaliacao_comentario FOREIGN KEY (id_comentario) REFERENCES comentario(id);
 V   ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT fk_avaliacao_comentario;
       public       postgres    false    208    203    2956         �           2606    18278 =   avaliacao_comentario fk_avaliacao_comentario_membro_avaliador    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT fk_avaliacao_comentario_membro_avaliador FOREIGN KEY (id_avaliador) REFERENCES membro(id);
 g   ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT fk_avaliacao_comentario_membro_avaliador;
       public       postgres    false    197    208    2942         �           2606    18478 (   avaliacao_postagem fk_avaliacao_postagem    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT fk_avaliacao_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 R   ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT fk_avaliacao_postagem;
       public       postgres    false    2958    205    207         �           2606    18483 9   avaliacao_postagem fk_avaliacao_postagem_membro_avaliador    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT fk_avaliacao_postagem_membro_avaliador FOREIGN KEY (id_avaliador) REFERENCES membro(id);
 c   ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT fk_avaliacao_postagem_membro_avaliador;
       public       postgres    false    207    197    2942         �           2606    18110 *   categoria_postagem fk_categoria_partilhada    FK CONSTRAINT     �   ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT fk_categoria_partilhada FOREIGN KEY (id_categoria_partilhada) REFERENCES categoria(id);
 T   ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT fk_categoria_partilhada;
       public       postgres    false    216    2968    209         �           2606    18104 2   categoria_postagem fk_categoria_postagem_categoria    FK CONSTRAINT     �   ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT fk_categoria_postagem_categoria FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 \   ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT fk_categoria_postagem_categoria;
       public       postgres    false    205    2958    216         �           2606    17809 '   denuncia fk_denuncia_membro_denunciante    FK CONSTRAINT     �   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_membro_denunciante FOREIGN KEY (id_denunciante) REFERENCES membro(id);
 Q   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_membro_denunciante;
       public       postgres    false    201    197    2942         �           2606    17814    denuncia fk_denuncia_postagem    FK CONSTRAINT     u   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 G   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_postagem;
       public       postgres    false    201    2958    205         �           2606    18169 "   denuncia fk_denuncia_tipo_denuncia    FK CONSTRAINT     �   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_tipo_denuncia FOREIGN KEY (id_tipo_denuncia) REFERENCES tipo_denuncia(id);
 L   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_tipo_denuncia;
       public       postgres    false    201    206    2960         �           2606    18052    inscrito fk_id_registrado    FK CONSTRAINT     r   ALTER TABLE ONLY inscrito
    ADD CONSTRAINT fk_id_registrado FOREIGN KEY (id_registrando) REFERENCES membro(id);
 C   ALTER TABLE ONLY public.inscrito DROP CONSTRAINT fk_id_registrado;
       public       postgres    false    213    197    2942         �           2606    18047    inscrito fk_id_registrando    FK CONSTRAINT     s   ALTER TABLE ONLY inscrito
    ADD CONSTRAINT fk_id_registrando FOREIGN KEY (id_registrando) REFERENCES membro(id);
 D   ALTER TABLE ONLY public.inscrito DROP CONSTRAINT fk_id_registrando;
       public       postgres    false    213    197    2942         �           2606    18548    imagem fk_imagem_album    FK CONSTRAINT     h   ALTER TABLE ONLY imagem
    ADD CONSTRAINT fk_imagem_album FOREIGN KEY (id_album) REFERENCES album(id);
 @   ALTER TABLE ONLY public.imagem DROP CONSTRAINT fk_imagem_album;
       public       postgres    false    226    2982    228         �           2606    17999    membro fk_membro_status_membro    FK CONSTRAINT     �   ALTER TABLE ONLY membro
    ADD CONSTRAINT fk_membro_status_membro FOREIGN KEY (id_status_membro) REFERENCES status_membro(id);
 H   ALTER TABLE ONLY public.membro DROP CONSTRAINT fk_membro_status_membro;
       public       postgres    false    197    2948    199         �           2606    18356 0   notificacao_comentario fk_notificacao_comentario    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT fk_notificacao_comentario FOREIGN KEY (id_comentario) REFERENCES comentario(id);
 Z   ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT fk_notificacao_comentario;
       public       postgres    false    2956    220    203         �           2606    18361 9   notificacao_comentario fk_notificacao_membro_destinatario    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT fk_notificacao_membro_destinatario FOREIGN KEY (id_destinatario) REFERENCES membro(id);
 c   ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT fk_notificacao_membro_destinatario;
       public       postgres    false    220    197    2942         �           2606    18373 7   notificacao_postagem fk_notificacao_membro_destinatario    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT fk_notificacao_membro_destinatario FOREIGN KEY (id_destinatario) REFERENCES membro(id);
 a   ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT fk_notificacao_membro_destinatario;
       public       postgres    false    219    197    2942         �           2606    18398 ,   notificacao_postagem fk_notificacao_postagem    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT fk_notificacao_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 V   ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT fk_notificacao_postagem;
       public       postgres    false    219    205    2958         �           2606    18028 (   postagem fk_postagem_classificaca_etaria    FK CONSTRAINT     �   ALTER TABLE ONLY postagem
    ADD CONSTRAINT fk_postagem_classificaca_etaria FOREIGN KEY (id_classificacao_etaria) REFERENCES classificacao_etaria(id);
 R   ALTER TABLE ONLY public.postagem DROP CONSTRAINT fk_postagem_classificaca_etaria;
       public       postgres    false    210    2972    205         �           2606    17968 $   postagem fk_postagem_membro_postante    FK CONSTRAINT     �   ALTER TABLE ONLY postagem
    ADD CONSTRAINT fk_postagem_membro_postante FOREIGN KEY (id_membro_postante) REFERENCES membro(id);
 N   ALTER TABLE ONLY public.postagem DROP CONSTRAINT fk_postagem_membro_postante;
       public       postgres    false    2942    205    197         �           2606    18936 9   registro_visualizacoes fk_registro_visualizacoes_postagem    FK CONSTRAINT     �   ALTER TABLE ONLY registro_visualizacoes
    ADD CONSTRAINT fk_registro_visualizacoes_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 c   ALTER TABLE ONLY public.registro_visualizacoes DROP CONSTRAINT fk_registro_visualizacoes_postagem;
       public       postgres    false    230    2958    205         �           2606    17829 )   comentario id_comentario_membro_remetente    FK CONSTRAINT     �   ALTER TABLE ONLY comentario
    ADD CONSTRAINT id_comentario_membro_remetente FOREIGN KEY (id_remetente) REFERENCES membro(id);
 S   ALTER TABLE ONLY public.comentario DROP CONSTRAINT id_comentario_membro_remetente;
       public       postgres    false    197    2942    203         �           2606    17824 !   comentario id_comentario_postagem    FK CONSTRAINT     y   ALTER TABLE ONLY comentario
    ADD CONSTRAINT id_comentario_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 K   ALTER TABLE ONLY public.comentario DROP CONSTRAINT id_comentario_postagem;
       public       postgres    false    2958    205    203                                                                                                                                                                           3163.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3166.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3145.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3144.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3146.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3153.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3147.dat                                                                                            0000600 0004000 0002000 00000006515 13307635546 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        VIOLÊNCIA FANTASIOSA	0	1	VIOLÊNCIA	A.1.1.
PRESENÇA DE ARMAS SEM VIOLÊNCIA	0	2	VIOLÊNCIA	A.1.2.
MORTES SEM VIOLÊNCIA	0	3	VIOLÊNCIA	A.1.3.
OSSADAS E ESQUELETOS SEM VIOLÊNCIA	0	4	VIOLÊNCIA	A.1.4.
PRESENÇA DE ARMAS COM VIOLÊNCIA	10	5	VIOLÊNCIA	A.2.1.
MEDO / TENSÃO	10	6	VIOLÊNCIA	A.2.2.
ANGÚSTIA	10	7	VIOLÊNCIA	A.2.3.
OSSADAS E ESQUELETOS COM RESQUÍCIOS DE ATO DE VIOLÊNCIA	10	8	VIOLÊNCIA	A.2.4.
ATOS CRIMINOSOS SEM VIOLÊNCIA	10	9	VIOLÊNCIA	A.2.5.
LINGUAGEM DEPRECIATIVA	10	10	VIOLÊNCIA	A.2.6.
ATO VIOLENTO	12	11	VIOLÊNCIA	A.3.1.
LESÃO CORPORAL	12	12	VIOLÊNCIA	A.3.2.
DESCRIÇÃO DE VIOLÊNCIA	12	13	VIOLÊNCIA	A.3.3.
PRESENÇA DE SANGUE	12	14	VIOLÊNCIA	A.3.4.
SOFRIMENTO DA VÍTIMA	12	15	VIOLÊNCIA	A.3.5.
MORTE NATURAL OU ACIDENTAL COM VIOLÊNCIA	12	16	VIOLÊNCIA	A.3.6.
ATO VIOLENTO CONTRA ANIMAIS	12	17	VIOLÊNCIA	A.3.7.
EXPOSIÇÃO AO PERIGO	12	18	VIOLÊNCIA	A.3.8.
EXPOSIÇÃO DE PESSOAS EM SITUAÇÕES CONSTRANGEDORAS OU	12	19	VIOLÊNCIA	A.3.9.
MORTE INTENCIONAL	14	20	VIOLÊNCIA	A.4.1.
ESTIGMA / PRECONCEITO	14	21	VIOLÊNCIA	A.4.2.
ESTUPRO1	16	22	VIOLÊNCIA	A.5.1.
EXPLORAÇÃO SEXUAL2	16	23	VIOLÊNCIA	A.5.2.
COAÇÃO SEXUAL	16	24	VIOLÊNCIA	A.5.3.
TORTURA	16	25	VIOLÊNCIA	A.5.4.
MUTILAÇÃO	16	26	VIOLÊNCIA	A.5.5.
SUICÍDIO	16	27	VIOLÊNCIA	A.5.6.
VIOLÊNCIA GRATUITA / BANALIZAÇÃO DA VIOLÊNCIA	16	28	VIOLÊNCIA	A.5.7.
ABORTO, PENA DE MORTE, EUTANÁSIA	16	29	VIOLÊNCIA	A.5.8.
VIOLÊNCIA DE FORTE IMPACTO	18	30	VIOLÊNCIA	A.6.1.
ELOGIO, GLAMOURIZAÇÃO E/OU APOLOGIA À VIOLÊNCIA	18	31	VIOLÊNCIA	A.6.2.
CRUELDADE	18	32	VIOLÊNCIA	A.6.3.
CRIMES DE ÓDIO	18	33	VIOLÊNCIA	A.6.4.
PEDOFILIA	18	34	VIOLÊNCIA	A.6.5.
NUDEZ NÃO ERÓTICA	0	35	SEXO E NUDEZ	B.1.1.
CONTEÚDOS EDUCATIVOS SOBRE SEXO	10	36	SEXO E NUDEZ	B.2.1.
NUDEZ VELADA	12	37	SEXO E NUDEZ	B.3.1.
CARÍCIAS SEXUAIS	12	38	SEXO E NUDEZ	B.3.3.
MASTURBAÇÃO	12	39	SEXO E NUDEZ	B.3.4.
LINGUAGEM CHULA	12	40	SEXO E NUDEZ	B.3.5.
LINGUAGEM DE CONTEÚDO SEXUAL	12	41	SEXO E NUDEZ	B.3.6.
SIMULAÇÕES DE SEXO	12	42	SEXO E NUDEZ	B.3.7.
APELO SEXUAL	12	43	SEXO E NUDEZ	B.3.8.
NUDEZ	14	44	SEXO E NUDEZ	B.4.1.
EROTIZAÇÃO	14	45	SEXO E NUDEZ	B.4.2.
VULGARIDADE	14	46	SEXO E NUDEZ	B.4.3.
RELAÇÃO SEXUAL	14	47	SEXO E NUDEZ	B.4.4.
PROSTITUIÇÃO	14	48	SEXO E NUDEZ	B.4.5.
RELAÇÃO SEXUAL INTENSA	16	49	SEXO E NUDEZ	B.5.1.
SEXO EXPLÍCITO	18	50	SEXO E NUDEZ	B.6.1.
SITUAÇÕES SEXUAIS COMPLEXAS / DE FORTE IMPACTO	18	51	SEXO E NUDEZ	B.6.2.
CONSUMO MODERADO OU INSINUADO DE DROGAS LÍCITAS	0	52	DROGAS	C.1.1.
DESCRIÇÕES VERBAIS DO CONSUMO DE DROGAS LÍCITAS	10	53	DROGAS	C.2.1.
DISCUSSÃO SOBRE O TEMA “TRÁFICO DE DROGAS”	10	54	DROGAS	C.2.2.
USO MEDICINAL DE DROGAS ILÍCITAS	10	55	DROGAS	C.2.3.
CONSUMO DE DROGAS LÍCITAS	12	56	DROGAS	C.3.1.
INDUÇÃO AO USO DE DROGAS LÍCITAS	12	57	DROGAS	C.3.2.
CONSUMO IRREGULAR DE MEDICAMENTOS	12	58	DROGAS	C.3.3.
MENÇÃO A DROGAS ILÍCITAS	12	59	DROGAS	C.3.4.
INSINUAÇÃO DO CONSUMO DE DROGAS ILÍCITAS	14	60	DROGAS	C.4.1.
DESCRIÇÕES VERBAIS DO CONSUMO E TRÁFICO DE DROGAS	14	61	DROGAS	C.4.2.
DISCUSSÃO SOBRE “DESCRIMINALIZAÇÃO DE DROGAS ILÍCITAS”	14	62	DROGAS	C.4.3.
PRODUÇÃO OU TRÁFICO DE QUALQUER DROGA ILÍCITA	16	63	DROGAS	C.5.1.
CONSUMO DE DROGAS ILÍCITAS	16	64	DROGAS	C.5.2.
INDUÇÃO AO CONSUMO DE DROGAS ILÍCITAS	16	65	DROGAS	C.5.3.
APOLOGIA AO USO DE DROGAS ILÍCITAS	18	66	DROGAS	C.6.1.
PENDENTE DE CLASSIFICACAO	0	67	NÃO CLASSIFICADO	S.1.1.
\.


                                                                                                                                                                                   3140.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3138.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3165.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3150.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3134.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3157.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3156.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3142.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3167.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3136.dat                                                                                            0000600 0004000 0002000 00000000356 13307635546 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        10	Inscrito na Plataforma Linker	Membro	14
100	Tipo especial de membro que possui acesso a alguns relatórios genéricos da aplicação	Patrocinador	15
200	Tipo especial de membro que possui atribuições de moderação	Moderador	16
\.


                                                                                                                                                                                                                                                                                  3143.dat                                                                                            0000600 0004000 0002000 00000000005 13307635546 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           restore.sql                                                                                         0000600 0004000 0002000 00000236446 13307635546 0015417 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.comentario DROP CONSTRAINT id_comentario_postagem;
ALTER TABLE ONLY public.comentario DROP CONSTRAINT id_comentario_membro_remetente;
ALTER TABLE ONLY public.registro_visualizacoes DROP CONSTRAINT fk_registro_visualizacoes_postagem;
ALTER TABLE ONLY public.postagem DROP CONSTRAINT fk_postagem_membro_postante;
ALTER TABLE ONLY public.postagem DROP CONSTRAINT fk_postagem_classificaca_etaria;
ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT fk_notificacao_postagem;
ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT fk_notificacao_membro_destinatario;
ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT fk_notificacao_membro_destinatario;
ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT fk_notificacao_comentario;
ALTER TABLE ONLY public.membro DROP CONSTRAINT fk_membro_status_membro;
ALTER TABLE ONLY public.imagem DROP CONSTRAINT fk_imagem_album;
ALTER TABLE ONLY public.inscrito DROP CONSTRAINT fk_id_registrando;
ALTER TABLE ONLY public.inscrito DROP CONSTRAINT fk_id_registrado;
ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_tipo_denuncia;
ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_postagem;
ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_membro_denunciante;
ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT fk_categoria_postagem_categoria;
ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT fk_categoria_partilhada;
ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT fk_avaliacao_postagem_membro_avaliador;
ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT fk_avaliacao_postagem;
ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT fk_avaliacao_comentario_membro_avaliador;
ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT fk_avaliacao_comentario;
ALTER TABLE ONLY public.album DROP CONSTRAINT fk_album_proprietario;
ALTER TABLE ONLY public.album_postagem DROP CONSTRAINT album_postagem_postagem;
ALTER TABLE ONLY public.tipo_denuncia DROP CONSTRAINT unique_tipo_denuncia;
ALTER TABLE ONLY public.membro DROP CONSTRAINT unique_membro_login_name;
ALTER TABLE ONLY public.membro DROP CONSTRAINT unique_membro_email;
ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT unique_classificaca_etaria_codigo;
ALTER TABLE ONLY public.categoria DROP CONSTRAINT unique_categoria_tipo;
ALTER TABLE ONLY public.tipo_denuncia DROP CONSTRAINT tipo_denuncia_pkey;
ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_unique_tipo;
ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_unique_nivel;
ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_pkey;
ALTER TABLE ONLY public.registro_visualizacoes DROP CONSTRAINT registro_visualizacoes_pkey;
ALTER TABLE ONLY public.postagem DROP CONSTRAINT postagem_pkey;
ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT notificacao_postagem_pkey;
ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT notificacao_comentario_pkey;
ALTER TABLE ONLY public.membro DROP CONSTRAINT membro_pkey;
ALTER TABLE ONLY public.imagem DROP CONSTRAINT imagens_pkey;
ALTER TABLE ONLY public.denuncia DROP CONSTRAINT denuncia_pkey;
ALTER TABLE ONLY public.comentario DROP CONSTRAINT comentario_pkey;
ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT classificacao_etaria_pkey;
ALTER TABLE public.membro DROP CONSTRAINT check_membro_menor_idade;
ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT categoria_postagem_pkey;
ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT avaliacao_postagem_pkey;
ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT avaliacao_comentario_pkey;
ALTER TABLE ONLY public.album_postagem DROP CONSTRAINT album_postagem_pkey;
ALTER TABLE ONLY public.album DROP CONSTRAINT album_pkey;
ALTER TABLE public.tipo_denuncia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.status_membro ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.registro_visualizacoes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.postagem ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.notificacao_postagem ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.notificacao_comentario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.membro ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.imagem ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.denuncia ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.comentario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.classificacao_etaria ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.categoria_postagem ALTER COLUMN id_postagem DROP DEFAULT;
ALTER TABLE public.categoria_postagem ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.avaliacao_postagem ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.avaliacao_comentario ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.album ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.tipo_denuncia_id_seq;
DROP TABLE public.tipo_denuncia;
DROP SEQUENCE public.status_membro_id_seq;
DROP SEQUENCE public.registro_visualizacoes_id_seq;
DROP TABLE public.registro_visualizacoes;
DROP SEQUENCE public.postagem_id_seq;
DROP SEQUENCE public.notificacao_postagem_id_seq;
DROP SEQUENCE public.notificacao_comentario_id_seq;
DROP TABLE public.notificacao_comentario;
DROP SEQUENCE public.membro_id_seq;
DROP SEQUENCE public.imagens_id_seq;
DROP SEQUENCE public.denuncia_id_seq;
DROP TABLE public.denuncia;
DROP SEQUENCE public.comentario_id_seq;
DROP TABLE public.comentario;
DROP SEQUENCE public.classificacao_etaria_id_seq;
DROP TABLE public.classificacao_etaria;
DROP SEQUENCE public.categoria_postagem_id_seq;
DROP SEQUENCE public.categoria_postagem_id_postagem_seq;
DROP TABLE public.categoria_postagem;
DROP SEQUENCE public.categoria_id_seq;
DROP TABLE public.categoria;
DROP SEQUENCE public.avaliacao_postagem_id_seq;
DROP SEQUENCE public.avaliacao_comentario_id_seq;
DROP TABLE public.avaliacao_comentario;
DROP SEQUENCE public.album_id_seq;
DROP TABLE public.album;
DROP FUNCTION public.registrartipodenuncia(_tipo character varying, _descricao character varying);
DROP FUNCTION public.registrarpostagem(_id_membro_postante bigint, _descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _titulo character varying, _patrocinador character varying);
DROP FUNCTION public.registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint);
DROP FUNCTION public.registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint);
DROP FUNCTION public.registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying);
DROP FUNCTION public.registrarinscrito(_id_registrando bigint, _id_registrado bigint);
DROP FUNCTION public.registrarimagemperfil(_id_proprietario bigint, _imagem bytea, _escala character varying);
DROP FUNCTION public.registrarimagem(_id_album bigint, _imagem bytea, _extensao character varying, _titulo character varying, _escala character varying);
DROP FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying);
DROP FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
DROP FUNCTION public.registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint);
DROP FUNCTION public.registrarclassificacaoetaria(_id integer, _classificacao character varying, _tipo character varying, _codigo character varying, _idade integer);
DROP FUNCTION public.registrarcategoria(_tipo character varying, _descricao character varying);
DROP FUNCTION public.registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean);
DROP FUNCTION public.registraravaliacao(_id_membro_avaliador bigint, _nota integer);
DROP FUNCTION public.registraralbumpostagem(_id_postagem bigint, _img_postagem bytea, _img_patrocinador bytea);
DROP FUNCTION public.registraralbum(_id_proprietario bigint, _nome_album character varying);
DROP FUNCTION public.atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
DROP FUNCTION public._verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint);
DROP TABLE public.notificacao_postagem;
DROP FUNCTION public._updatetotalvisualizacoespostagem(_id_postagem bigint);
DROP FUNCTION public._notificarinscritos(_id_publicador bigint, _id_postagem bigint);
DROP FUNCTION public._logar(_login_name character varying, _pass bytea);
DROP TABLE public.membro;
DROP FUNCTION public._if_ternario(boolean, anyelement, anyelement);
DROP FUNCTION public._getinscritos(_id_membro bigint);
DROP TABLE public.inscrito;
DROP FUNCTION public._getimagemperfil(_id_proprietario bigint, _escala character varying);
DROP TABLE public.imagem;
DROP FUNCTION public._getavaliacaopostagem(_id_avaliador bigint, _id_postagem bigint);
DROP TABLE public.avaliacao_postagem;
DROP FUNCTION public._getalbumpostagem(_id_postagem bigint);
DROP TABLE public.album_postagem;
DROP FUNCTION public._editarsenha(_id_membro bigint, _pass bytea, _old_pass bytea);
DROP FUNCTION public._editarloginname(_id_membro bigint, _login_name character varying, _old_login_name character varying, _pass bytea);
DROP FUNCTION public._editarcadastromembro(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _pass bytea);
DROP FUNCTION public._denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
DROP FUNCTION public._consultarstatusmembro(_tipo character varying);
DROP TABLE public.status_membro;
DROP FUNCTION public._consultarpostagembytitulo(_titulo character varying, _start bigint, _limit bigint);
DROP TABLE public.postagem;
DROP FUNCTION public._consultarmembrominbypostagemid(_id_postagem bigint);
DROP FUNCTION public._atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean);
DROP FUNCTION public._atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean);
DROP EXTENSION citext;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET search_path = public, pg_catalog;

--
-- Name: _atualizaravaliacaocomentario(bigint, bigint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
    	declare
            preAvaliacao boolean;
    	begin 
        	select is_positiva into preAvaliacao from avaliacao_comentario where avaliacao_comentario.id = _id_avaliacao_comentario limit 1;
        	if(_is_positiva and not preAvaliacao) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas + 1, avaliacoes_negativas = avaliacoes_negativas - 1
                	where comentario.id = _id_comentario;
            elsif(not _is_positiva and preAvaliacao) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas - 1, avaliacoes_negativas = avaliacoes_negativas + 1
                	where comentario.id = _id_comentario;
            else
            	if(_is_positiva) then
                	update comentario set avaliacoes_positivas = avaliacoes_positivas - 1 where comentario.id = _id_comentario;
                else
                	update comentario set avaliacoes_negativas = avaliacoes_negativas - 1 where comentario.id = _id_comentario;
                end if;
             	return 'REMOVE';
            end if;
            update avaliacao_comentario set is_positiva = _is_positiva where avaliacao_comentario.id = _id_avaliacao_comentario;
            return 'TROCA';
		end
    $$;


ALTER FUNCTION public._atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean) OWNER TO postgres;

--
-- Name: _atualizaravaliacaopostagem(bigint, bigint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
    	declare
            preAvaliacao boolean;
    	begin 
        	select is_positiva into preAvaliacao from avaliacao_postagem where avaliacao_postagem.id = _id_avaliacao_postagem limit 1;
        	if(_is_positiva and not preAvaliacao) then
            	update postagem set avaliacoes_positivas = avaliacoes_positivas + 1, avaliacoes_negativas = avaliacoes_negativas - 1
                	where postagem.id = _id_postagem;
            elsif(not _is_positiva and preAvaliacao) then
            	update postagem set avaliacoes_positivas = avaliacoes_positivas - 1, avaliacoes_negativas = avaliacoes_negativas + 1
                	where postagem.id = _id_postagem;
            else
            	if(_is_positiva) then
                	update postagem set avaliacoes_positivas = avaliacoes_positivas - 1 where postagem.id = _id_postagem;
                else
                	update postagem set avaliacoes_negativas = avaliacoes_negativas - 1 where postagem.id = _id_postagem;
                end if;
             	return 'REMOVE';
            end if;
            update avaliacao_postagem set is_positiva = _is_positiva where avaliacao_postagem.id = _id_avaliacao_postagem;
            return 'TROCA';
		end
    $$;


ALTER FUNCTION public._atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean) OWNER TO postgres;

--
-- Name: _consultarmembrominbypostagemid(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _consultarmembrominbypostagemid(_id_postagem bigint) RETURNS TABLE(id_membro bigint, nome_membro character varying, total_inscritos bigint, data_inscricao date, is_suspenso boolean, imagem_membro bytea, has_image boolean)
    LANGUAGE plpgsql
    AS $$
		declare
        	get_id bigint;
        	get_nome character varying;
        	get_total_inscritos bigint;
        	get_data_inscricao date;
       		get_is_sustenso boolean;
        	get_imagem bytea;
    	begin
        	
        	select 
            	membro.id,
        		membro.nome::character varying,
        		membro.total_inscritos,
        		membro.data_inscricao,
       			membro.is_suspenso,
        		imagem.imagem
                	into
                		get_id,
        				get_nome,
        				get_total_inscritos,
        				get_data_inscricao,
       					get_is_sustenso,
        				get_imagem    
            	from postagem, membro, album, imagem 
                	where 
                    	postagem.id = _id_postagem
                        and membro.id = postagem.id_membro_postante
                        and album.id_proprietario = postagem.id_membro_postante
                        and album.nome_album = 'perfil'
                        and album.id = imagem.id_album limit 1;  
               	return query select get_id,
        				get_nome,
        				get_total_inscritos,
        				get_data_inscricao,
       					get_is_sustenso,
        				get_imagem, get_imagem is not null;  
        end
    $$;


ALTER FUNCTION public._consultarmembrominbypostagemid(_id_postagem bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: postagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE postagem (
    id bigint NOT NULL,
    descricao citext,
    vetor_url_site character varying,
    vetor_url_video character varying,
    vetor_url_imagem character varying,
    titulo citext NOT NULL,
    patrocinador character varying(200),
    id_classificacao_etaria smallint DEFAULT 67 NOT NULL,
    id_membro_postante bigint NOT NULL,
    data_postagem timestamp(4) with time zone DEFAULT now() NOT NULL,
    visualizacoes bigint DEFAULT 0 NOT NULL,
    is_suspensa boolean DEFAULT false NOT NULL,
    avaliacoes_positivas bigint DEFAULT 0 NOT NULL,
    avaliacoes_negativas bigint DEFAULT 0 NOT NULL
);


ALTER TABLE postagem OWNER TO postgres;

--
-- Name: _consultarpostagembytitulo(character varying, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _consultarpostagembytitulo(_titulo character varying, _start bigint, _limit bigint) RETURNS SETOF postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from postagem where titulo like '%'||_titulo||'%' and id > _start limit _limit; 
        end
    $$;


ALTER FUNCTION public._consultarpostagembytitulo(_titulo character varying, _start bigint, _limit bigint) OWNER TO postgres;

--
-- Name: status_membro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE status_membro (
    nivel smallint NOT NULL,
    descricao character varying NOT NULL,
    tipo citext NOT NULL,
    id smallint NOT NULL
);


ALTER TABLE status_membro OWNER TO postgres;

--
-- Name: _consultarstatusmembro(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _consultarstatusmembro(_tipo character varying) RETURNS SETOF status_membro
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            return query select * from status_membro where status_membro.tipo = _tipo::citext limit 1;   
		end
    $$;


ALTER FUNCTION public._consultarstatusmembro(_tipo character varying) OWNER TO postgres;

--
-- Name: _denunciar(bigint, bigint, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS TABLE(id_denuncia bigint, is_suspenso boolean)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            total_denuncias integer;
            suspensa boolean;
    	begin
        	select id into newId from registrarDenuncia(
    			_id_denunciante,
    			_id_postagem,
    			_id_tipo_denuncia,
   				_relato
            ) as id; 
             SELECT count(id) INTO total_denuncias FROM denuncia where denuncia.id_postagem = _id_postagem;
             suspensa = total_denuncias > 49;
            if(suspensa) then
            	update postagem set is_suspensa = true;
            end if;
           	return query select newId, suspensa;        
		end
    $$;


ALTER FUNCTION public._denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) OWNER TO postgres;

--
-- Name: _editarcadastromembro(bigint, character varying, date, character, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _editarcadastromembro(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _pass bytea) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    	declare
        	_id bigint;
    	begin
        	select id into _id from membro where membro.id = _id_membro and membro.pass = _pass limit 1;
            if(_id is null) then
            return false;
            end if;
        	update membro set nome = _nome, sexo = _sexo, nascimento = _nascimento 
            	where id = _id_membro and pass = _pass; 
            return true;
		end
    $$;


ALTER FUNCTION public._editarcadastromembro(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _pass bytea) OWNER TO postgres;

--
-- Name: _editarloginname(bigint, character varying, character varying, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _editarloginname(_id_membro bigint, _login_name character varying, _old_login_name character varying, _pass bytea) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    	declare
            get_login_name character varying;
            get_pass bytea;
    	begin
        	select login_name, pass into get_login_name, get_pass from membro 
            	where membro.id = _id_membro limit 1;
            if(get_login_name <> _old_login_name) then
            	return 'O nome de login esta errado';
            elsif(get_pass <> _pass) THEN
            	return 'A senha esta incorreta';
            end if;
            update membro set login_name = _login_name where membro.id = _id_membro;
            return 'SUCCES';            
		end
    $$;


ALTER FUNCTION public._editarloginname(_id_membro bigint, _login_name character varying, _old_login_name character varying, _pass bytea) OWNER TO postgres;

--
-- Name: _editarsenha(bigint, bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _editarsenha(_id_membro bigint, _pass bytea, _old_pass bytea) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    	declare
            get_pass character varying;
    	begin
        	select pass into get_pass from membro 
            	where membro.id = _id_membro and pass = _old_pass limit 1;
            if(get_pass is not null) then
            	update membro set pass = _pass where id = _id_membro;
            	return true;
            end if;        	 
            return false;
		end
    $$;


ALTER FUNCTION public._editarsenha(_id_membro bigint, _pass bytea, _old_pass bytea) OWNER TO postgres;

--
-- Name: album_postagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE album_postagem (
    id_postagem bigint NOT NULL,
    img_postagem bytea,
    img_patrocinador bytea
);


ALTER TABLE album_postagem OWNER TO postgres;

--
-- Name: _getalbumpostagem(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _getalbumpostagem(_id_postagem bigint) RETURNS SETOF album_postagem
    LANGUAGE plpgsql
    AS $$
        begin
        	return query select * from album_postagem where id_postagem = _id_postagem limit 1;
        end
        $$;


ALTER FUNCTION public._getalbumpostagem(_id_postagem bigint) OWNER TO postgres;

--
-- Name: avaliacao_postagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE avaliacao_postagem (
    id_avaliador bigint NOT NULL,
    id_postagem bigint NOT NULL,
    is_positiva boolean NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE avaliacao_postagem OWNER TO postgres;

--
-- Name: _getavaliacaopostagem(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _getavaliacaopostagem(_id_avaliador bigint, _id_postagem bigint) RETURNS SETOF avaliacao_postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from avaliacao_postagem where id_postagem = _id_postagem and id_avaliador = _id_avaliador limit 1;
		end
    $$;


ALTER FUNCTION public._getavaliacaopostagem(_id_avaliador bigint, _id_postagem bigint) OWNER TO postgres;

--
-- Name: imagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE imagem (
    id bigint NOT NULL,
    imagem bytea NOT NULL,
    extensao citext NOT NULL,
    titulo citext NOT NULL,
    escala citext NOT NULL,
    data_inclusao timestamp(4) with time zone DEFAULT now() NOT NULL,
    id_album bigint NOT NULL,
    CONSTRAINT imagem_escala_pequena_media_grande CHECK (((escala = 'pequena'::citext) OR (escala = 'media'::citext) OR (escala = 'grande'::citext)))
);


ALTER TABLE imagem OWNER TO postgres;

--
-- Name: _getimagemperfil(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _getimagemperfil(_id_proprietario bigint, _escala character varying) RETURNS SETOF imagem
    LANGUAGE plpgsql
    AS $$
        	declare
            	_id_album bigint;
        	begin
            	select id into _id_album from album
                	where album.id_proprietario = _id_proprietario and album.nome_album = 'perfil' limit 1;
                
                return query select * from imagem where id_album = _id_album and escala = _escala::citext limit 1;
            end
        $$;


ALTER FUNCTION public._getimagemperfil(_id_proprietario bigint, _escala character varying) OWNER TO postgres;

--
-- Name: inscrito; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE inscrito (
    id_registrando bigint NOT NULL,
    id_registrado bigint NOT NULL,
    data_inscricao date DEFAULT (now())::date NOT NULL,
    CONSTRAINT check_inscrito_registrando_difere_registrado CHECK ((id_registrando <> id_registrado))
);


ALTER TABLE inscrito OWNER TO postgres;

--
-- Name: _getinscritos(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _getinscritos(_id_membro bigint) RETURNS SETOF inscrito
    LANGUAGE plpgsql
    AS $$
    	begin 
        	return query select * from inscrito where  id_registrando = _id_membro;
		end
    $$;


ALTER FUNCTION public._getinscritos(_id_membro bigint) OWNER TO postgres;

--
-- Name: _if_ternario(boolean, anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _if_ternario(boolean, anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql
    AS $_$
  select case when $1 is true then $2 else $3 end;
$_$;


ALTER FUNCTION public._if_ternario(boolean, anyelement, anyelement) OWNER TO postgres;

--
-- Name: membro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE membro (
    login_name citext NOT NULL,
    pass bytea NOT NULL,
    email citext NOT NULL,
    is_suspenso boolean DEFAULT false NOT NULL,
    is_banido boolean DEFAULT false NOT NULL,
    sexo "char" NOT NULL,
    nascimento date NOT NULL,
    nome citext NOT NULL,
    id bigint NOT NULL,
    id_status_membro smallint DEFAULT 14 NOT NULL,
    total_inscritos bigint DEFAULT 0 NOT NULL,
    data_inscricao date DEFAULT (now())::date NOT NULL,
    acesso time with time zone DEFAULT now() NOT NULL,
    tentativas_acesso smallint DEFAULT 0 NOT NULL,
    db_key integer DEFAULT (- trunc(((random() * (999999999)::double precision) + (1357)::double precision))) NOT NULL
);


ALTER TABLE membro OWNER TO postgres;

--
-- Name: _logar(character varying, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _logar(_login_name character varying, _pass bytea) RETURNS SETOF membro
    LANGUAGE plpgsql
    AS $$
    	begin
            return query select * from membro where login_name = _login_name and pass = _pass limit 1;        
		end
    $$;


ALTER FUNCTION public._logar(_login_name character varying, _pass bytea) OWNER TO postgres;

--
-- Name: _notificarinscritos(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _notificarinscritos(_id_publicador bigint, _id_postagem bigint) RETURNS TABLE(_id_inscrito bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
        	_id_registrado bigint;
    	begin 
        	for _id_registrado in select id_registrado from _getInscritos(_id_publicador) loop
            	perform registrarNotificacaoPostagem(_id_registrado,_id_postagem);
                return query select _id_registrado;
            end loop;  
  		end
    $$;


ALTER FUNCTION public._notificarinscritos(_id_publicador bigint, _id_postagem bigint) OWNER TO postgres;

--
-- Name: _updatetotalvisualizacoespostagem(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _updatetotalvisualizacoespostagem(_id_postagem bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
        	get_visualizacoes bigint;
    	begin 
        	update postagem set visualizacoes = visualizacoes + 1 
            	where postagem.id = _id_postagem RETURNING postagem.visualizacoes into get_visualizacoes;
            	if(mod(get_visualizacoes, 10000) = 0) then
            		insert into registro_visualizacoes(id_postagem, counter) values(_id_postagem, get_visualizacoes);
            	end if;
            return visualizacoes from postagem where id = _id_postagem;
		end
    $$;


ALTER FUNCTION public._updatetotalvisualizacoespostagem(_id_postagem bigint) OWNER TO postgres;

--
-- Name: notificacao_postagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE notificacao_postagem (
    id_postagem bigint NOT NULL,
    id_destinatario bigint NOT NULL,
    is_pendente boolean DEFAULT true NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE notificacao_postagem OWNER TO postgres;

--
-- Name: _verificar_notificacao_postagem(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint) RETURNS SETOF notificacao_postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from notificacao_postagem where id_destinatario = _id_destinatario
            and id > _pre_start and is_pendente limit _limit;      
		end
    $$;


ALTER FUNCTION public._verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint) OWNER TO postgres;

--
-- Name: atualizardenuncias(bigint, bigint, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS TABLE(id_denuncia bigint, is_suspenso boolean)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            total_denuncias integer;
    	begin
        	select id into newId from registrarDenuncia(
    			_id_denunciante,
    			_id_postagem,
    			_id_tipo_denuncia,
   				_relato
            ); 
             SELECT count(id) INTO total_denuncias FROM denuncia where denuncia.id_postagem = _id_postagem;
            if(total_denuncias > 49) then
            	update postagem set postagem.is_suspenso = true;
            end if;
           	return query select newId, total_denuncias > 49;        
		end
    $$;


ALTER FUNCTION public.atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) OWNER TO postgres;

--
-- Name: registraralbum(bigint, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registraralbum(_id_proprietario bigint, _nome_album character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
        	select id into newId from album where id_proprietario = _id_proprietario and _nome_album::citext = 'perfil'::citext limit 1;
            if(newId is null) then
            	insert into album(id_proprietario, nome_album) 
                	values(_id_proprietario,_nome_album) returning album.id into newId;	
            end if;            
			return newId;         
		end
    $$;


ALTER FUNCTION public.registraralbum(_id_proprietario bigint, _nome_album character varying) OWNER TO postgres;

--
-- Name: registraralbumpostagem(bigint, bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registraralbumpostagem(_id_postagem bigint, _img_postagem bytea, _img_patrocinador bytea) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
        begin
        	if(_img_postagem is not null or _img_patrocinador is not null) then
            	insert into album_postagem values(_id_postagem, _img_postagem, _img_patrocinador);
                return true;
            end if;
                return false;
           	end
        $$;


ALTER FUNCTION public.registraralbumpostagem(_id_postagem bigint, _img_postagem bytea, _img_patrocinador bytea) OWNER TO postgres;

--
-- Name: registraravaliacao(bigint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registraravaliacao(_id_membro_avaliador bigint, _nota integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
        insert into avaliacao(id_membro_avaliador, nota)
        	values(_id_membro_avaliador, _nota) returning avaliacao.id into newId;  
			return newId;         
		end
    $$;


ALTER FUNCTION public.registraravaliacao(_id_membro_avaliador bigint, _nota integer) OWNER TO postgres;

--
-- Name: registraravaliacaopostagem(bigint, bigint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean) RETURNS TABLE(_id bigint, acao text, _avaliacoes_positivas bigint, _avaliacoes_negativas bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            retorno_atualizacao text;
            get_avaliacoes_positivas bigint;
            get_avaliacoes_negativas bigint;
    	begin
        	select id into newId from avaliacao_postagem 
        		where avaliacao_postagem.id_avaliador = _id_avaliador
            		and avaliacao_postagem.id_postagem = _id_postagem limit 1;
        	if(newId is null) then        	
				insert into avaliacao_postagem(id_avaliador, id_postagem,is_positiva) values(_id_avaliador, _id_postagem,_is_positiva) returning avaliacao_postagem.id into newId; 
            	if(_is_positiva) then
            		update postagem set avaliacoes_positivas = avaliacoes_positivas + 1 where postagem.id = _id_postagem;
            	else
            		update postagem set avaliacoes_negativas = avaliacoes_negativas + 1 where postagem.id = _id_postagem;
            	end if;
        	        select avaliacoes_positivas, avaliacoes_negativas into get_avaliacoes_positivas, get_avaliacoes_negativas from postagem where postagem.id = _id_postagem limit 1;
                    return query select newId, 'REGISTRA', get_avaliacoes_positivas, get_avaliacoes_negativas;
       		else
        		select atualizacao into retorno_atualizacao from _atualizarAvaliacaopostagem( newId, _id_postagem, _is_positiva) as atualizacao;
        		if(retorno_atualizacao = 'REMOVE') then
            		delete from avaliacao_postagem where avaliacao_postagem.id = newId;
            	end if; 
        	        select avaliacoes_positivas, avaliacoes_negativas into get_avaliacoes_positivas, get_avaliacoes_negativas from postagem where postagem.id = _id_postagem limit 1;
	            	return query select newId,retorno_atualizacao, get_avaliacoes_positivas, get_avaliacoes_negativas;
        	end if;        
		end
    $$;


ALTER FUNCTION public.registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean) OWNER TO postgres;

--
-- Name: registrarcategoria(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarcategoria(_tipo character varying, _descricao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into categoria(tipo, descricao)
            values(_tipo, _descricao) returning categoria.id into newId;
			return newId;         
		end
    $$;


ALTER FUNCTION public.registrarcategoria(_tipo character varying, _descricao character varying) OWNER TO postgres;

--
-- Name: registrarclassificacaoetaria(integer, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarclassificacaoetaria(_id integer, _classificacao character varying, _tipo character varying, _codigo character varying, _idade integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into classificacao_etaria(id,classificacao, tipo, codigo, idade)
            values(_id, _classificacao, _tipo, _codigo, _idade) returning classificacao_etaria.id into newId;
			return newId;         
		end
    $$;


ALTER FUNCTION public.registrarclassificacaoetaria(_id integer, _classificacao character varying, _tipo character varying, _codigo character varying, _idade integer) OWNER TO postgres;

--
-- Name: registrarcomentario(character varying, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint) RETURNS TABLE(_id bigint, _data_comentario timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
    	declare
    		get_id bigint;
            get_data_comentario timestamp with time zone;
    	begin
            insert into comentario(comentario, id_remetente, id_postagem) 
            	values(_comentario, _id_remetente, _id_postagem) 
                	returning comentario.id, comentario.data_comentario into get_id, get_data_comentario;
			return query select get_id,get_data_comentario;         
		end
    $$;


ALTER FUNCTION public.registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint) OWNER TO postgres;

--
-- Name: registrardenuncia(bigint, bigint, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
        	select id into newId from denuncia 
            		where denuncia.id_denunciante = _id_denunciante
                    	and denuncia.id_postagem = _id_postagem
                        	and denuncia.id_tipo_denuncia = _id_tipo_denuncia limit 1;
                            
            	if(newId is null) then 
            		insert into denuncia(id_denunciante, id_postagem, id_tipo_denuncia, relato) 
            			values(_id_denunciante, _id_postagem, _id_tipo_denuncia, _relato) returning denuncia.id into newId;
				end if;
            return newId;         
		end
    $$;


ALTER FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) OWNER TO postgres;

--
-- Name: registrardenuncia(bigint, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into denuncia(id_denunciante, id_postagem, id_tipo_denuncia, relato) 
            	values(_id_denunciante, _id_postagem, _id_tipo_denuncia, _relato) returning denuncia.id into newId;
			return newId;         
		end
    $$;


ALTER FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying) OWNER TO postgres;

--
-- Name: registrarimagem(bigint, bytea, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarimagem(_id_album bigint, _imagem bytea, _extensao character varying, _titulo character varying, _escala character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
            insert into imagem(id_album, imagem, extensao,titulo,escala)
            values(_id_album, _imagem, _extensao,_titulo,_escala) returning imagem.id into newId;
			return newId;         
		end
    $$;


ALTER FUNCTION public.registrarimagem(_id_album bigint, _imagem bytea, _extensao character varying, _titulo character varying, _escala character varying) OWNER TO postgres;

--
-- Name: registrarimagemperfil(bigint, bytea, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarimagemperfil(_id_proprietario bigint, _imagem bytea, _escala character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
        declare 
        _id_album bigint;
        newId bigint;
        
        begin
        	select id into _id_album from album where id_proprietario = _id_proprietario and nome_album = 'perfil' limit 1;
            select id into newId from imagem where id_album = _id_album and escala = _escala;
            if(newId is null) then
            	insert into imagem(id_album, imagem, titulo,escala, extensao)
                	values(_id_album, _imagem, 'perfil',_escala, 'jpg') returning imagem.id into newId;
            else
            	update imagem set imagem = _imagem where id_album = _id_album and escala = _escala;
            end if;
            return newId;
        end
        $$;


ALTER FUNCTION public.registrarimagemperfil(_id_proprietario bigint, _imagem bytea, _escala character varying) OWNER TO postgres;

--
-- Name: registrarinscrito(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarinscrito(_id_registrando bigint, _id_registrado bigint) RETURNS TABLE(registro boolean, _total_inscritos bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
        	isRegistrado bigint;
    	begin 
        	if(_id_registrando <> _id_registrado) then 
            	select _id_registrado into isRegistrado from inscrito 
            		where inscrito.id_registrado = _id_registrado and inscrito.id_registrando = _id_registrando limit 1;                
                if(isRegistrado is null) then
            		insert into inscrito(id_registrando, id_registrado) values(_id_registrando, _id_registrado);
                    update membro set total_inscritos = total_inscritos + 1 where id = _id_registrando;
                else
                	update membro set total_inscritos = total_inscritos - 1 where id = _id_registrando;
                    delete from inscrito where id_registrando = _id_registrando and id_registrado = _id_registrado;
                end if;	
            end if; 
            return query select isRegistrado is null,(select total_inscritos from membro where id = _id_registrando limit 1);
		end
    $$;


ALTER FUNCTION public.registrarinscrito(_id_registrando bigint, _id_registrado bigint) OWNER TO postgres;

--
-- Name: registrarmembro(character varying, date, character, character varying, bytea, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying) RETURNS TABLE(_id_membro bigint, _db_key bigint)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            db_key bigint;
    	begin
            insert into membro(login_name, pass, email, sexo, nascimento, nome)
            values(_login_name, _pass, _email, _sexo, _nascimento, _nome) returning membro.id, membro.db_key into newId, db_key;
            perform registrarAlbum(newId, 'perfil');
			return query select newId, db_key;         
		end
    $$;


ALTER FUNCTION public.registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying) OWNER TO postgres;

--
-- Name: registrarnotificacaocomentario(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare        
        	newId bigint;
    	begin 
        	insert into notificacao_comentario(id_comentario, id_destinatario) 
            	values(_id_comentario, _id_destinatario) returning notificacao_comentario.id into newId;
			return newId; 
		end
    $$;


ALTER FUNCTION public.registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint) OWNER TO postgres;

--
-- Name: registrarnotificacaopostagem(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare        
        	newId bigint;
    	begin 
        	insert into notificacao_postagem(id_postagem, id_destinatario) 
            	values(_id_postagem, _id_destinatario) returning notificacao_postagem.id into newId;
			return newId; 
		end
    $$;


ALTER FUNCTION public.registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint) OWNER TO postgres;

--
-- Name: registrarpostagem(bigint, character varying, character varying[], character varying[], character varying[], character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrarpostagem(_id_membro_postante bigint, _descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _titulo character varying, _patrocinador character varying) RETURNS TABLE(_id bigint, _visualizacoes bigint, _avaliacoes_positivas bigint, _avaliacoes_negativas bigint, _is_suspensa boolean, _data_postagem date)
    LANGUAGE plpgsql
    AS $$
    declare
    get_id bigint;
    get_visualizacoes bigint;
    get_avaliacoes_positivas bigint;
    get_avaliacoes_negativas bigint;
    get_is_suspensa boolean;
    get_data_postagem date;
    begin
    insert into postagem(
        	descricao, 
        	vetor_url_site,
        	vetor_url_video,
        	vetor_url_imagem,
        	titulo,
        	patrocinador,
        	id_membro_postante	
    		)
            	values(	
                    _descricao, 
                    _vetor_url_site, 
                    _vetor_url_video,
                    _vetor_url_imagem,
                    _titulo,
                    _patrocinador,
                    _id_membro_postante
                ) 
            	returning 
                	postagem.id, 
                    postagem.visualizacoes, 
                    postagem.avaliacoes_positivas,
                    postagem.avaliacoes_negativas,
                    postagem.is_suspensa,
                    postagem.data_postagem 
                    	into 
                        	get_id,
                            get_visualizacoes,
                            get_avaliacoes_positivas,
                            get_avaliacoes_negativas,
                            get_is_suspensa,
                            get_data_postagem;
			return query select get_id,
                            get_visualizacoes,
                            get_avaliacoes_positivas,
                            get_avaliacoes_negativas,
                            get_is_suspensa,
                            get_data_postagem;         
		end
    $$;


ALTER FUNCTION public.registrarpostagem(_id_membro_postante bigint, _descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _titulo character varying, _patrocinador character varying) OWNER TO postgres;

--
-- Name: registrartipodenuncia(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrartipodenuncia(_tipo character varying, _descricao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into tipo_denuncia(tipo, descricao) values(_tipo, _descricao) returning tipo_denuncia.id into newId;
			return newId;         
		end
    $$;


ALTER FUNCTION public.registrartipodenuncia(_tipo character varying, _descricao character varying) OWNER TO postgres;

--
-- Name: album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE album (
    id bigint NOT NULL,
    id_proprietario bigint NOT NULL,
    data_criacao timestamp with time zone DEFAULT now() NOT NULL,
    total_imagens integer DEFAULT 0 NOT NULL,
    nome_album citext NOT NULL
);


ALTER TABLE album OWNER TO postgres;

--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE album_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE album_id_seq OWNER TO postgres;

--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE album_id_seq OWNED BY album.id;


--
-- Name: avaliacao_comentario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE avaliacao_comentario (
    id_avaliador bigint NOT NULL,
    id_comentario bigint NOT NULL,
    is_positiva boolean NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE avaliacao_comentario OWNER TO postgres;

--
-- Name: avaliacao_comentario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE avaliacao_comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avaliacao_comentario_id_seq OWNER TO postgres;

--
-- Name: avaliacao_comentario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE avaliacao_comentario_id_seq OWNED BY avaliacao_comentario.id;


--
-- Name: avaliacao_postagem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE avaliacao_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE avaliacao_postagem_id_seq OWNER TO postgres;

--
-- Name: avaliacao_postagem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE avaliacao_postagem_id_seq OWNED BY avaliacao_postagem.id;


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE categoria (
    tipo citext NOT NULL,
    descricao character varying NOT NULL,
    id smallint NOT NULL
);


ALTER TABLE categoria OWNER TO postgres;

--
-- Name: categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categoria_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categoria_id_seq OWNER TO postgres;

--
-- Name: categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categoria_id_seq OWNED BY categoria.id;


--
-- Name: categoria_postagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE categoria_postagem (
    id bigint NOT NULL,
    id_categoria_partilhada smallint NOT NULL,
    id_postagem bigint NOT NULL
);


ALTER TABLE categoria_postagem OWNER TO postgres;

--
-- Name: categoria_postagem_id_postagem_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categoria_postagem_id_postagem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categoria_postagem_id_postagem_seq OWNER TO postgres;

--
-- Name: categoria_postagem_id_postagem_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categoria_postagem_id_postagem_seq OWNED BY categoria_postagem.id_postagem;


--
-- Name: categoria_postagem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE categoria_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categoria_postagem_id_seq OWNER TO postgres;

--
-- Name: categoria_postagem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE categoria_postagem_id_seq OWNED BY categoria_postagem.id;


--
-- Name: classificacao_etaria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE classificacao_etaria (
    tipo citext NOT NULL,
    idade smallint NOT NULL,
    id smallint NOT NULL,
    classificacao citext NOT NULL,
    codigo citext NOT NULL
);


ALTER TABLE classificacao_etaria OWNER TO postgres;

--
-- Name: classificacao_etaria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE classificacao_etaria_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE classificacao_etaria_id_seq OWNER TO postgres;

--
-- Name: classificacao_etaria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE classificacao_etaria_id_seq OWNED BY classificacao_etaria.id;


--
-- Name: comentario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE comentario (
    id bigint NOT NULL,
    is_editado boolean DEFAULT false NOT NULL,
    data_comentario timestamp(4) with time zone DEFAULT now() NOT NULL,
    comentario citext NOT NULL,
    id_postagem bigint NOT NULL,
    id_remetente bigint NOT NULL,
    avaliacoes_positivas bigint DEFAULT 0 NOT NULL,
    avaliacoes_negativas bigint DEFAULT 0 NOT NULL
);


ALTER TABLE comentario OWNER TO postgres;

--
-- Name: comentario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comentario_id_seq OWNER TO postgres;

--
-- Name: comentario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comentario_id_seq OWNED BY comentario.id;


--
-- Name: denuncia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE denuncia (
    id bigint NOT NULL,
    id_denunciante bigint NOT NULL,
    id_postagem bigint NOT NULL,
    id_tipo_denuncia smallint NOT NULL,
    relato character varying(300),
    data_denuncia timestamp(4) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE denuncia OWNER TO postgres;

--
-- Name: denuncia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE denuncia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE denuncia_id_seq OWNER TO postgres;

--
-- Name: denuncia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE denuncia_id_seq OWNED BY denuncia.id;


--
-- Name: imagens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE imagens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE imagens_id_seq OWNER TO postgres;

--
-- Name: imagens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE imagens_id_seq OWNED BY imagem.id;


--
-- Name: membro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE membro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE membro_id_seq OWNER TO postgres;

--
-- Name: membro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE membro_id_seq OWNED BY membro.id;


--
-- Name: notificacao_comentario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE notificacao_comentario (
    id bigint NOT NULL,
    id_comentario bigint NOT NULL,
    id_destinatario bigint NOT NULL,
    is_pendente boolean DEFAULT true NOT NULL
);


ALTER TABLE notificacao_comentario OWNER TO postgres;

--
-- Name: notificacao_comentario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE notificacao_comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notificacao_comentario_id_seq OWNER TO postgres;

--
-- Name: notificacao_comentario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE notificacao_comentario_id_seq OWNED BY notificacao_comentario.id;


--
-- Name: notificacao_postagem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE notificacao_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notificacao_postagem_id_seq OWNER TO postgres;

--
-- Name: notificacao_postagem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE notificacao_postagem_id_seq OWNED BY notificacao_postagem.id;


--
-- Name: postagem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE postagem_id_seq OWNER TO postgres;

--
-- Name: postagem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE postagem_id_seq OWNED BY postagem.id;


--
-- Name: registro_visualizacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE registro_visualizacoes (
    id_postagem bigint NOT NULL,
    data_registro timestamp(4) with time zone DEFAULT now() NOT NULL,
    counter bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE registro_visualizacoes OWNER TO postgres;

--
-- Name: registro_visualizacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE registro_visualizacoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE registro_visualizacoes_id_seq OWNER TO postgres;

--
-- Name: registro_visualizacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE registro_visualizacoes_id_seq OWNED BY registro_visualizacoes.id;


--
-- Name: status_membro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE status_membro_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE status_membro_id_seq OWNER TO postgres;

--
-- Name: status_membro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE status_membro_id_seq OWNED BY status_membro.id;


--
-- Name: tipo_denuncia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tipo_denuncia (
    id smallint NOT NULL,
    tipo citext NOT NULL,
    descricao citext NOT NULL
);


ALTER TABLE tipo_denuncia OWNER TO postgres;

--
-- Name: tipo_denuncia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tipo_denuncia_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tipo_denuncia_id_seq OWNER TO postgres;

--
-- Name: tipo_denuncia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tipo_denuncia_id_seq OWNED BY tipo_denuncia.id;


--
-- Name: album id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY album ALTER COLUMN id SET DEFAULT nextval('album_id_seq'::regclass);


--
-- Name: avaliacao_comentario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_comentario ALTER COLUMN id SET DEFAULT nextval('avaliacao_comentario_id_seq'::regclass);


--
-- Name: avaliacao_postagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_postagem ALTER COLUMN id SET DEFAULT nextval('avaliacao_postagem_id_seq'::regclass);


--
-- Name: categoria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria ALTER COLUMN id SET DEFAULT nextval('categoria_id_seq'::regclass);


--
-- Name: categoria_postagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria_postagem ALTER COLUMN id SET DEFAULT nextval('categoria_postagem_id_seq'::regclass);


--
-- Name: categoria_postagem id_postagem; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria_postagem ALTER COLUMN id_postagem SET DEFAULT nextval('categoria_postagem_id_postagem_seq'::regclass);


--
-- Name: classificacao_etaria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY classificacao_etaria ALTER COLUMN id SET DEFAULT nextval('classificacao_etaria_id_seq'::regclass);


--
-- Name: comentario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comentario ALTER COLUMN id SET DEFAULT nextval('comentario_id_seq'::regclass);


--
-- Name: denuncia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY denuncia ALTER COLUMN id SET DEFAULT nextval('denuncia_id_seq'::regclass);


--
-- Name: imagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY imagem ALTER COLUMN id SET DEFAULT nextval('imagens_id_seq'::regclass);


--
-- Name: membro id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY membro ALTER COLUMN id SET DEFAULT nextval('membro_id_seq'::regclass);


--
-- Name: notificacao_comentario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_comentario ALTER COLUMN id SET DEFAULT nextval('notificacao_comentario_id_seq'::regclass);


--
-- Name: notificacao_postagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_postagem ALTER COLUMN id SET DEFAULT nextval('notificacao_postagem_id_seq'::regclass);


--
-- Name: postagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postagem ALTER COLUMN id SET DEFAULT nextval('postagem_id_seq'::regclass);


--
-- Name: registro_visualizacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registro_visualizacoes ALTER COLUMN id SET DEFAULT nextval('registro_visualizacoes_id_seq'::regclass);


--
-- Name: status_membro id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY status_membro ALTER COLUMN id SET DEFAULT nextval('status_membro_id_seq'::regclass);


--
-- Name: tipo_denuncia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_denuncia ALTER COLUMN id SET DEFAULT nextval('tipo_denuncia_id_seq'::regclass);


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY album (id, id_proprietario, data_criacao, total_imagens, nome_album) FROM stdin;
\.
COPY album (id, id_proprietario, data_criacao, total_imagens, nome_album) FROM '$$PATH$$/3163.dat';

--
-- Data for Name: album_postagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY album_postagem (id_postagem, img_postagem, img_patrocinador) FROM stdin;
\.
COPY album_postagem (id_postagem, img_postagem, img_patrocinador) FROM '$$PATH$$/3166.dat';

--
-- Data for Name: avaliacao_comentario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY avaliacao_comentario (id_avaliador, id_comentario, is_positiva, id) FROM stdin;
\.
COPY avaliacao_comentario (id_avaliador, id_comentario, is_positiva, id) FROM '$$PATH$$/3145.dat';

--
-- Data for Name: avaliacao_postagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY avaliacao_postagem (id_avaliador, id_postagem, is_positiva, id) FROM stdin;
\.
COPY avaliacao_postagem (id_avaliador, id_postagem, is_positiva, id) FROM '$$PATH$$/3144.dat';

--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY categoria (tipo, descricao, id) FROM stdin;
\.
COPY categoria (tipo, descricao, id) FROM '$$PATH$$/3146.dat';

--
-- Data for Name: categoria_postagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY categoria_postagem (id, id_categoria_partilhada, id_postagem) FROM stdin;
\.
COPY categoria_postagem (id, id_categoria_partilhada, id_postagem) FROM '$$PATH$$/3153.dat';

--
-- Data for Name: classificacao_etaria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY classificacao_etaria (tipo, idade, id, classificacao, codigo) FROM stdin;
\.
COPY classificacao_etaria (tipo, idade, id, classificacao, codigo) FROM '$$PATH$$/3147.dat';

--
-- Data for Name: comentario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comentario (id, is_editado, data_comentario, comentario, id_postagem, id_remetente, avaliacoes_positivas, avaliacoes_negativas) FROM stdin;
\.
COPY comentario (id, is_editado, data_comentario, comentario, id_postagem, id_remetente, avaliacoes_positivas, avaliacoes_negativas) FROM '$$PATH$$/3140.dat';

--
-- Data for Name: denuncia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY denuncia (id, id_denunciante, id_postagem, id_tipo_denuncia, relato, data_denuncia) FROM stdin;
\.
COPY denuncia (id, id_denunciante, id_postagem, id_tipo_denuncia, relato, data_denuncia) FROM '$$PATH$$/3138.dat';

--
-- Data for Name: imagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY imagem (id, imagem, extensao, titulo, escala, data_inclusao, id_album) FROM stdin;
\.
COPY imagem (id, imagem, extensao, titulo, escala, data_inclusao, id_album) FROM '$$PATH$$/3165.dat';

--
-- Data for Name: inscrito; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY inscrito (id_registrando, id_registrado, data_inscricao) FROM stdin;
\.
COPY inscrito (id_registrando, id_registrado, data_inscricao) FROM '$$PATH$$/3150.dat';

--
-- Data for Name: membro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY membro (login_name, pass, email, is_suspenso, is_banido, sexo, nascimento, nome, id, id_status_membro, total_inscritos, data_inscricao, acesso, tentativas_acesso, db_key) FROM stdin;
\.
COPY membro (login_name, pass, email, is_suspenso, is_banido, sexo, nascimento, nome, id, id_status_membro, total_inscritos, data_inscricao, acesso, tentativas_acesso, db_key) FROM '$$PATH$$/3134.dat';

--
-- Data for Name: notificacao_comentario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY notificacao_comentario (id, id_comentario, id_destinatario, is_pendente) FROM stdin;
\.
COPY notificacao_comentario (id, id_comentario, id_destinatario, is_pendente) FROM '$$PATH$$/3157.dat';

--
-- Data for Name: notificacao_postagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY notificacao_postagem (id_postagem, id_destinatario, is_pendente, id) FROM stdin;
\.
COPY notificacao_postagem (id_postagem, id_destinatario, is_pendente, id) FROM '$$PATH$$/3156.dat';

--
-- Data for Name: postagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY postagem (id, descricao, vetor_url_site, vetor_url_video, vetor_url_imagem, titulo, patrocinador, id_classificacao_etaria, id_membro_postante, data_postagem, visualizacoes, is_suspensa, avaliacoes_positivas, avaliacoes_negativas) FROM stdin;
\.
COPY postagem (id, descricao, vetor_url_site, vetor_url_video, vetor_url_imagem, titulo, patrocinador, id_classificacao_etaria, id_membro_postante, data_postagem, visualizacoes, is_suspensa, avaliacoes_positivas, avaliacoes_negativas) FROM '$$PATH$$/3142.dat';

--
-- Data for Name: registro_visualizacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY registro_visualizacoes (id_postagem, data_registro, counter, id) FROM stdin;
\.
COPY registro_visualizacoes (id_postagem, data_registro, counter, id) FROM '$$PATH$$/3167.dat';

--
-- Data for Name: status_membro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY status_membro (nivel, descricao, tipo, id) FROM stdin;
\.
COPY status_membro (nivel, descricao, tipo, id) FROM '$$PATH$$/3136.dat';

--
-- Data for Name: tipo_denuncia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tipo_denuncia (id, tipo, descricao) FROM stdin;
\.
COPY tipo_denuncia (id, tipo, descricao) FROM '$$PATH$$/3143.dat';

--
-- Name: album_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('album_id_seq', 88, true);


--
-- Name: avaliacao_comentario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('avaliacao_comentario_id_seq', 112, true);


--
-- Name: avaliacao_postagem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('avaliacao_postagem_id_seq', 174, true);


--
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('categoria_id_seq', 13, true);


--
-- Name: categoria_postagem_id_postagem_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('categoria_postagem_id_postagem_seq', 1, false);


--
-- Name: categoria_postagem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('categoria_postagem_id_seq', 1, true);


--
-- Name: classificacao_etaria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('classificacao_etaria_id_seq', 1, true);


--
-- Name: comentario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comentario_id_seq', 86, true);


--
-- Name: denuncia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('denuncia_id_seq', 9, true);


--
-- Name: imagens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('imagens_id_seq', 99, true);


--
-- Name: membro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('membro_id_seq', 157, true);


--
-- Name: notificacao_comentario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacao_comentario_id_seq', 4, true);


--
-- Name: notificacao_postagem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('notificacao_postagem_id_seq', 582, true);


--
-- Name: postagem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('postagem_id_seq', 210, true);


--
-- Name: registro_visualizacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('registro_visualizacoes_id_seq', 14, true);


--
-- Name: status_membro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('status_membro_id_seq', 19, true);


--
-- Name: tipo_denuncia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tipo_denuncia_id_seq', 3, true);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- Name: album_postagem album_postagem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY album_postagem
    ADD CONSTRAINT album_postagem_pkey PRIMARY KEY (id_postagem);


--
-- Name: avaliacao_comentario avaliacao_comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT avaliacao_comentario_pkey PRIMARY KEY (id);


--
-- Name: avaliacao_postagem avaliacao_postagem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT avaliacao_postagem_pkey PRIMARY KEY (id);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- Name: categoria_postagem categoria_postagem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT categoria_postagem_pkey PRIMARY KEY (id);


--
-- Name: membro check_membro_menor_idade; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE membro
    ADD CONSTRAINT check_membro_menor_idade CHECK ((date_part('years'::text, age((nascimento)::timestamp with time zone)) > (17)::double precision)) NOT VALID;


--
-- Name: classificacao_etaria classificacao_etaria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT classificacao_etaria_pkey PRIMARY KEY (id);


--
-- Name: comentario comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id);


--
-- Name: denuncia denuncia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY denuncia
    ADD CONSTRAINT denuncia_pkey PRIMARY KEY (id);


--
-- Name: imagem imagens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY imagem
    ADD CONSTRAINT imagens_pkey PRIMARY KEY (id);


--
-- Name: membro membro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY membro
    ADD CONSTRAINT membro_pkey PRIMARY KEY (id);


--
-- Name: notificacao_comentario notificacao_comentario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT notificacao_comentario_pkey PRIMARY KEY (id);


--
-- Name: notificacao_postagem notificacao_postagem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT notificacao_postagem_pkey PRIMARY KEY (id);


--
-- Name: postagem postagem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postagem
    ADD CONSTRAINT postagem_pkey PRIMARY KEY (id);


--
-- Name: registro_visualizacoes registro_visualizacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registro_visualizacoes
    ADD CONSTRAINT registro_visualizacoes_pkey PRIMARY KEY (id);


--
-- Name: status_membro status_membro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_pkey PRIMARY KEY (id);


--
-- Name: status_membro status_membro_unique_nivel; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_unique_nivel UNIQUE (nivel);


--
-- Name: status_membro status_membro_unique_tipo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_unique_tipo UNIQUE (tipo);


--
-- Name: tipo_denuncia tipo_denuncia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_denuncia
    ADD CONSTRAINT tipo_denuncia_pkey PRIMARY KEY (id);


--
-- Name: categoria unique_categoria_tipo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT unique_categoria_tipo UNIQUE (tipo);


--
-- Name: classificacao_etaria unique_classificaca_etaria_codigo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT unique_classificaca_etaria_codigo UNIQUE (codigo);


--
-- Name: membro unique_membro_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY membro
    ADD CONSTRAINT unique_membro_email UNIQUE (email);


--
-- Name: membro unique_membro_login_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY membro
    ADD CONSTRAINT unique_membro_login_name UNIQUE (login_name);


--
-- Name: tipo_denuncia unique_tipo_denuncia; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_denuncia
    ADD CONSTRAINT unique_tipo_denuncia UNIQUE (tipo);


--
-- Name: album_postagem album_postagem_postagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY album_postagem
    ADD CONSTRAINT album_postagem_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- Name: album fk_album_proprietario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY album
    ADD CONSTRAINT fk_album_proprietario FOREIGN KEY (id_proprietario) REFERENCES membro(id);


--
-- Name: avaliacao_comentario fk_avaliacao_comentario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT fk_avaliacao_comentario FOREIGN KEY (id_comentario) REFERENCES comentario(id);


--
-- Name: avaliacao_comentario fk_avaliacao_comentario_membro_avaliador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT fk_avaliacao_comentario_membro_avaliador FOREIGN KEY (id_avaliador) REFERENCES membro(id);


--
-- Name: avaliacao_postagem fk_avaliacao_postagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT fk_avaliacao_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- Name: avaliacao_postagem fk_avaliacao_postagem_membro_avaliador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT fk_avaliacao_postagem_membro_avaliador FOREIGN KEY (id_avaliador) REFERENCES membro(id);


--
-- Name: categoria_postagem fk_categoria_partilhada; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT fk_categoria_partilhada FOREIGN KEY (id_categoria_partilhada) REFERENCES categoria(id);


--
-- Name: categoria_postagem fk_categoria_postagem_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT fk_categoria_postagem_categoria FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- Name: denuncia fk_denuncia_membro_denunciante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_membro_denunciante FOREIGN KEY (id_denunciante) REFERENCES membro(id);


--
-- Name: denuncia fk_denuncia_postagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- Name: denuncia fk_denuncia_tipo_denuncia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_tipo_denuncia FOREIGN KEY (id_tipo_denuncia) REFERENCES tipo_denuncia(id);


--
-- Name: inscrito fk_id_registrado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inscrito
    ADD CONSTRAINT fk_id_registrado FOREIGN KEY (id_registrando) REFERENCES membro(id);


--
-- Name: inscrito fk_id_registrando; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY inscrito
    ADD CONSTRAINT fk_id_registrando FOREIGN KEY (id_registrando) REFERENCES membro(id);


--
-- Name: imagem fk_imagem_album; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY imagem
    ADD CONSTRAINT fk_imagem_album FOREIGN KEY (id_album) REFERENCES album(id);


--
-- Name: membro fk_membro_status_membro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY membro
    ADD CONSTRAINT fk_membro_status_membro FOREIGN KEY (id_status_membro) REFERENCES status_membro(id);


--
-- Name: notificacao_comentario fk_notificacao_comentario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT fk_notificacao_comentario FOREIGN KEY (id_comentario) REFERENCES comentario(id);


--
-- Name: notificacao_comentario fk_notificacao_membro_destinatario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT fk_notificacao_membro_destinatario FOREIGN KEY (id_destinatario) REFERENCES membro(id);


--
-- Name: notificacao_postagem fk_notificacao_membro_destinatario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT fk_notificacao_membro_destinatario FOREIGN KEY (id_destinatario) REFERENCES membro(id);


--
-- Name: notificacao_postagem fk_notificacao_postagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT fk_notificacao_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- Name: postagem fk_postagem_classificaca_etaria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postagem
    ADD CONSTRAINT fk_postagem_classificaca_etaria FOREIGN KEY (id_classificacao_etaria) REFERENCES classificacao_etaria(id);


--
-- Name: postagem fk_postagem_membro_postante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY postagem
    ADD CONSTRAINT fk_postagem_membro_postante FOREIGN KEY (id_membro_postante) REFERENCES membro(id);


--
-- Name: registro_visualizacoes fk_registro_visualizacoes_postagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registro_visualizacoes
    ADD CONSTRAINT fk_registro_visualizacoes_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- Name: comentario id_comentario_membro_remetente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comentario
    ADD CONSTRAINT id_comentario_membro_remetente FOREIGN KEY (id_remetente) REFERENCES membro(id);


--
-- Name: comentario id_comentario_postagem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comentario
    ADD CONSTRAINT id_comentario_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          