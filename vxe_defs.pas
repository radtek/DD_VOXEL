//------------------------------------------------------------------------------
//
//  DD_VOXEL: DelphiDoom Voxel Editor
//  Copyright (C) 2013-2018 by Jim Valavanis
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.
//
// DESCRIPTION:
//  Settings(ini file)
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/delphidoom-voxel-editor/
//          https://sourceforge.net/projects/delphidoom/files/DDVoxels/
//------------------------------------------------------------------------------

unit vxe_defs;

interface

function vxe_LoadSettingFromFile(const fn: string): boolean;

procedure vxe_SaveSettingsToFile(const fn: string);

const
  MAXHISTORYPATH = 2048;

type
  bigstring_t = array[0..MAXHISTORYPATH - 1] of char;
  bigstring_p = ^bigstring_t;

var
  opt_useglpixels: Boolean = false;
  opt_renderaxes: Boolean = true;
  opt_renderglgrid: Boolean = true;
  opt_renderwireframe: Boolean = false;
  opt_filemenuhistory0: bigstring_t;
  opt_filemenuhistory1: bigstring_t;
  opt_filemenuhistory2: bigstring_t;
  opt_filemenuhistory3: bigstring_t;
  opt_filemenuhistory4: bigstring_t;
  opt_filemenuhistory5: bigstring_t;
  opt_filemenuhistory6: bigstring_t;
  opt_filemenuhistory7: bigstring_t;
  opt_filemenuhistory8: bigstring_t;
  opt_filemenuhistory9: bigstring_t;
  spritesavetype: string = 'WAD';
  spritesavepalette: string = 'DOOM';
  spriteangles: integer = 8;
  spritequality: boolean = False;
  spriteprefix: string = 'AAAAA';
  spriteformat: string = 'LMP';
  spritesaveperspective: boolean = True;
  spriteviewheight: integer = 41;
  spritedistance: integer = 1024;
  spriteexportpreviewzoom: integer = 1;

function bigstringtostring(const bs: bigstring_p): string;

procedure stringtobigstring(const src: string; const bs: bigstring_p);

implementation

uses
  SysUtils, Classes;

const
  NUMSETTINGS = 27;

type
  TSettingsType = (tstDevider, tstInteger, tstBoolean, tstString, tstBigString);

  TSettingItem = record
    desc: string;
    typeof: TSettingsType;
    location: pointer;
  end;

var
  Settings: array[0..NUMSETTINGS - 1] of TSettingItem = (
    (
      desc: '[OpenGL]';
      typeof: tstDevider;
      location: nil;
    ),
    (
      desc: 'GL_PIXELS';
      typeof: tstBoolean;
      location: @opt_useglpixels;
    ),
    (
      desc: 'GL_RENDERAXES';
      typeof: tstBoolean;
      location: @opt_renderaxes;
    ),
    (
      desc: 'GL_RENDERGRID';
      typeof: tstBoolean;
      location: @opt_renderglgrid;
    ),
    (
      desc: 'GL_RENDERWIREFRAME';
      typeof: tstBoolean;
      location: @opt_renderwireframe;
    ),
    (
      desc: '[File Menu History]';
      typeof: tstDevider;
      location: nil;
    ),
    (
      desc: 'FILEMENUHISTORY0';
      typeof: tstBigString;
      location: @opt_filemenuhistory0;
    ),
    (
      desc: 'FILEMENUHISTORY1';
      typeof: tstBigString;
      location: @opt_filemenuhistory1;
    ),
    (
      desc: 'FILEMENUHISTORY2';
      typeof: tstBigString;
      location: @opt_filemenuhistory2;
    ),
    (
      desc: 'FILEMENUHISTORY3';
      typeof: tstBigString;
      location: @opt_filemenuhistory3;
    ),
    (
      desc: 'FILEMENUHISTORY4';
      typeof: tstBigString;
      location: @opt_filemenuhistory4;
    ),
    (
      desc: 'FILEMENUHISTORY5';
      typeof: tstBigString;
      location: @opt_filemenuhistory5;
    ),
    (
      desc: 'FILEMENUHISTORY6';
      typeof: tstBigString;
      location: @opt_filemenuhistory6;
    ),
    (
      desc: 'FILEMENUHISTORY7';
      typeof: tstBigString;
      location: @opt_filemenuhistory7;
    ),
    (
      desc: 'FILEMENUHISTORY8';
      typeof: tstBigString;
      location: @opt_filemenuhistory8;
    ),
    (
      desc: 'FILEMENUHISTORY9';
      typeof: tstBigString;
      location: @opt_filemenuhistory9;
    ),
    (
      desc: '[Sprite Export]';
      typeof: tstDevider;
      location: nil;
    ),
    (
      desc: 'SPRITESAVETYPE';
      typeof: tstString;
      location: @spritesavetype;
    ),
    (
      desc: 'SPRITESAVEPALETTE';
      typeof: tstString;
      location: @spritesavepalette;
    ),
    (
      desc: 'SPRITEANGLES';
      typeof: tstInteger;
      location: @spriteangles;
    ),
    (
      desc: 'SPRITEQUALITY';
      typeof: tstBoolean;
      location: @spritequality;
    ),
    (
      desc: 'SPRITEPREFIX';
      typeof: tstString;
      location: @spriteprefix;
    ),
    (
      desc: 'SPRITEFORMAT';
      typeof: tstString;
      location: @spriteformat;
    ),
    (
      desc: 'SPRITESAVEPERSPECTIVE';
      typeof: tstBoolean;
      location: @spritesaveperspective;
    ),
    (
      desc: 'SPRITEPERSPECTIVEVIEWHEIGHT';
      typeof: tstInteger;
      location: @spriteviewheight;
    ),
    (
      desc: 'SPRITEPERSPECTIVEDISTANCE';
      typeof: tstInteger;
      location: @spritedistance;
    ),
    (
      desc: 'SPRITEEXPORTPREVIEWZOOM';
      typeof: tstInteger;
      location: @spriteexportpreviewzoom;
    )

  );


procedure splitstring(const inp: string; var out1, out2: string; const splitter: string = ' ');
var
  p: integer;
begin
  p := Pos(splitter, inp);
  if p = 0 then
  begin
    out1 := inp;
    out2 := '';
  end
  else
  begin
    out1 := Trim(Copy(inp, 1, p - 1));
    out2 := Trim(Copy(inp, p + 1, Length(inp) - p));
  end;
end;

function IntToBool(const x: integer): boolean;
begin
  Result := x <> 0;
end;

function BoolToInt(const b: boolean): integer;
begin
  if b then
    Result := 1
  else
    Result := 0;
end;

function bigstringtostring(const bs: bigstring_p): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to MAXHISTORYPATH - 1 do
    if bs[i] = #0 then
      Exit
    else
      Result := Result + bs[i];
end;

procedure stringtobigstring(const src: string; const bs: bigstring_p);
var
  i: integer;
begin
  for i := 0 to MAXHISTORYPATH - 1 do
    bs[i] := #0;

  for i := 1 to Length(src) do
  begin
    bs[i - 1] := src[i];
    if i = MAXHISTORYPATH then
      Exit;
  end;
end;

procedure vxe_SaveSettingsToFile(const fn: string);
var
  s: TStringList;
  i: integer;
begin
  s := TStringList.Create;
  try
    for i := 0 to NUMSETTINGS - 1 do
    begin
      if Settings[i].typeof = tstInteger then
        s.Add(Format('%s=%d', [Settings[i].desc, PInteger(Settings[i].location)^]))
      else if Settings[i].typeof = tstBoolean then
        s.Add(Format('%s=%d', [Settings[i].desc, BoolToInt(PBoolean(Settings[i].location)^)]))
      else if Settings[i].typeof = tstBigString then
        s.Add(Format('%s=%s', [Settings[i].desc, bigstringtostring(bigstring_p(Settings[i].location))]))
      else if Settings[i].typeof = tstString then
        s.Add(Format('%s=%s', [Settings[i].desc, PString(Settings[i].location)^]))
      else if Settings[i].typeof = tstDevider then
      begin
        if s.Count > 0 then
          s.Add('');
        s.Add(Settings[i].desc);
      end;
    end;
    s.SaveToFile(fn);
  finally
    s.Free;
  end;
end;

function vxe_LoadSettingFromFile(const fn: string): boolean;
var
  s: TStringList;
  i, j: integer;
  s1, s2: string;
  itmp: integer;
begin
  if not FileExists(fn) then
  begin
    result := false;
    exit;
  end;
  result := true;

  s := TStringList.Create;
  try
    s.LoadFromFile(fn);
    begin
      for i := 0 to s.Count - 1 do
      begin
        splitstring(s.Strings[i], s1, s2, '=');
        if s2 <> '' then
        begin
          s1 := UpperCase(s1);
          for j := 0 to NUMSETTINGS - 1 do
            if UpperCase(Settings[j].desc) = s1 then
            begin
              if Settings[j].typeof = tstInteger then
              begin
                itmp := StrToIntDef(s2, PInteger(Settings[j].location)^);
                PInteger(Settings[j].location)^ := itmp;
              end
              else if Settings[j].typeof = tstBoolean then
              begin
                itmp := StrToIntDef(s2, BoolToInt(PBoolean(Settings[j].location)^));
                PBoolean(Settings[j].location)^ := IntToBool(itmp);
              end
              else if Settings[j].typeof = tstString then
              begin
                PString(Settings[j].location)^ := s2;
              end
              else if Settings[j].typeof = tstBigString then
              begin
                stringtobigstring(s2, bigstring_p(Settings[j].location));
              end;
            end;
        end;
      end;
    end;
  finally
    s.Free;
  end;

end;

end.

